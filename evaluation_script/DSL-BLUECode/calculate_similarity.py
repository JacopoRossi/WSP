from codebleu import calc_codebleu
from nltk.translate.bleu_score import sentence_bleu, SmoothingFunction
import warnings
warnings.filterwarnings('ignore')

# Parser DSL custom
from dsl_parser import (
    DSLParser,
    calculate_syntax_similarity,
    calculate_dataflow_similarity,
    calculate_structural_similarity
)


def load_file(filepath):
    """Carica il contenuto di un file"""
    with open(filepath, 'r', encoding='utf-8') as f:
        return f.read()


def calculate_bleu_fallback(reference, hypothesis):
    """
    Calcola BLEU score come fallback quando CodeBLEU non è disponibile
    """
    # Tokenizza in parole
    ref_tokens = reference.split()
    hyp_tokens = hypothesis.split()
    
    # Calcola BLEU con smoothing
    smoothing = SmoothingFunction()
    
    # BLEU-1, BLEU-2, BLEU-3, BLEU-4
    bleu1 = sentence_bleu([ref_tokens], hyp_tokens, weights=(1, 0, 0, 0), 
                          smoothing_function=smoothing.method1)
    bleu2 = sentence_bleu([ref_tokens], hyp_tokens, weights=(0.5, 0.5, 0, 0),
                          smoothing_function=smoothing.method1)
    bleu3 = sentence_bleu([ref_tokens], hyp_tokens, weights=(0.33, 0.33, 0.33, 0),
                          smoothing_function=smoothing.method1)
    bleu4 = sentence_bleu([ref_tokens], hyp_tokens, weights=(0.25, 0.25, 0.25, 0.25),
                          smoothing_function=smoothing.method1)
    
    # Media pesata (simile a CodeBLEU ma senza syntax/dataflow)
    avg_bleu = (bleu1 + bleu2 + bleu3 + bleu4) / 4
    
    return {
        'bleu_score': avg_bleu,
        'bleu1': bleu1,
        'bleu2': bleu2,
        'bleu3': bleu3,
        'bleu4': bleu4,
        'ngram_match_score': bleu4,
        'weighted_ngram_match_score': avg_bleu,
        'syntax_match_score': 0.0,  # Non disponibile per DSL custom
        'dataflow_match_score': 0.0  # Non disponibile per DSL custom
    }


def calculate_dsl_similarity(reference, hypothesis):
    """
    Calcola DSL-CodeBLEU per DSL custom con parser specifico
    Include BLEU + syntax matching + dataflow matching
    """
    print(f"\n🔍 Parsing DSL con parser custom...")
    
    # Parsa i DSL
    ref_parser = DSLParser(reference)
    hyp_parser = DSLParser(hypothesis)
    
    try:
        ref_parser.parse()
        hyp_parser.parse()
        print("   ✅ Parsing completato con successo")
    except Exception as e:
        print(f"   ❌ Errore nel parsing: {e}")
        print("   Fallback a BLEU standard...")
        bleu_result = calculate_bleu_fallback(reference, hypothesis)
        return {'codebleu': bleu_result['bleu_score']}
    
    # Calcola BLEU
    bleu_result = calculate_bleu_fallback(reference, hypothesis)
    
    # Calcola metriche strutturali
    print(f"   🔬 Calcolo metriche strutturali...")
    structural = calculate_structural_similarity(ref_parser, hyp_parser)
    
    # Calcola syntax e dataflow similarity
    syntax_score = structural['syntax_similarity']
    dataflow_score = structural['dataflow_similarity']
    
    # Combina le metriche per calcolare DSL-CodeBLEU
    # Pesi: BLEU-4 (25%), Weighted BLEU (25%), Syntax (25%), Dataflow (25%)
    codebleu_score = (
        bleu_result['bleu4'] * 0.25 +
        bleu_result['weighted_ngram_match_score'] * 0.25 +
        syntax_score * 0.25 +
        dataflow_score * 0.25
    )
    
    return {'codebleu': codebleu_score}


def calculate_similarity(reference_file, hypothesis_file, lang='text'):
    """
    Calcola CodeBLEU tra due file
    
    Args:
        reference_file: Path al file di riferimento (ground truth)
        hypothesis_file: Path al file generato/da confrontare
        lang: Linguaggio per il parsing (text, python, java, etc.)
    
    Returns:
        dict: Dizionario con i risultati di CodeBLEU
    """
    print("=" * 60)
    print("Calcolo Similarità CodeBLEU")
    print("=" * 60)
    
    # Carica i file
    print(f"\n📄 Caricamento file di riferimento: {reference_file}")
    reference = load_file(reference_file)
    
    print(f"📄 Caricamento file ipotesi: {hypothesis_file}")
    hypothesis = load_file(hypothesis_file)
    
    print(f"\n📊 Statistiche:")
    print(f"   - Riferimento: {len(reference)} caratteri, {len(reference.splitlines())} righe")
    print(f"   - Ipotesi: {len(hypothesis)} caratteri, {len(hypothesis.splitlines())} righe")
    
    # Calcola CodeBLEU o BLEU o DSL custom
    use_dsl_parser = False
    use_fallback = False
    supported_langs = ['java', 'javascript', 'c_sharp', 'php', 'c', 'cpp', 'python', 'go', 'ruby', 'rust']
    
    if lang not in supported_langs:
        print(f"\n⚠️  Linguaggio '{lang}' non supportato da CodeBLEU")
        print(f"   Linguaggi supportati: {supported_langs}")
        
        # Prova a usare il parser DSL custom
        if lang in ['text', 'dsl', 'yaml']:
            print(f"   🎯 Uso parser DSL custom (con syntax/dataflow matching)")
            use_dsl_parser = True
        else:
            print(f"   Uso BLEU standard (senza syntax/dataflow matching)")
            use_fallback = True
    
    try:
        if use_dsl_parser:
            result = calculate_dsl_similarity(reference, hypothesis)
        elif use_fallback:
            print(f"\n🔬 Calcolo BLEU Score...")
            result = calculate_bleu_fallback(reference, hypothesis)
            result['codebleu'] = result['bleu_score']
        else:
            print(f"\n🔬 Calcolo CodeBLEU...")
            print(f"   Linguaggio: {lang}")
            result = calc_codebleu(
                references=[reference],
                predictions=[hypothesis],
                lang=lang,
                weights=(0.25, 0.25, 0.25, 0.25),
                tokenizer=None
            )
        
        print("\n" + "=" * 60)
        print("📈 RISULTATI")
        print("=" * 60)
        
        if use_dsl_parser:
            print(f"\n🎯 DSL-CodeBLEU Score: {result['codebleu']:.4f}")
        elif use_fallback:
            print(f"\n🎯 BLEU Score: {result['bleu_score']:.4f}")
        else:
            print(f"\n🎯 CodeBLEU Score: {result['codebleu']:.4f}")
        
        print("\n💡 Interpretazione:")
        score = result.get('codebleu', result.get('bleu_score', 0))
        if score >= 0.9:
            print("   ✅ Altissima similarità (90-100%)")
        elif score >= 0.75:
            print("   ✅ Alta similarità (75-89%)")
        elif score >= 0.5:
            print("   ⚠️  Similarità moderata (50-74%)")
        elif score >= 0.25:
            print("   ⚠️  Bassa similarità (25-49%)")
        else:
            print("   ❌ Similarità molto bassa (<25%)")
        
        print("\n" + "=" * 60)
        
        return result
        
    except Exception as e:
        print(f"\n❌ Errore durante il calcolo: {e}")
        print("\nProva a cambiare il parametro 'lang' a uno supportato o usa il fallback BLEU")
        raise


def main():
    # File da confrontare
    reference_file = "52_task.dsl"
    hypothesis_file = "52_task_bis.dsl"
    
    # Lingue supportate: 'java', 'js', 'c_sharp', 'php', 'go', 'python', 'ruby', 'rust'
    # Per DSL custom, usa 'text'
    language = "text"
    
    result = calculate_similarity(reference_file, hypothesis_file, language)
    
    # Salva risultati in un file
    output_file = "similarity_results.txt"
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("=" * 60 + "\n")
        f.write("RISULTATI SIMILARITÀ\n")
        f.write("=" * 60 + "\n\n")
        f.write(f"File di riferimento: {reference_file}\n")
        f.write(f"File ipotesi: {hypothesis_file}\n")
        f.write(f"Linguaggio: {language}\n\n")
        
        # Determina il tipo di score
        if language in ['text', 'dsl', 'yaml']:
            score_name = "DSL-CodeBLEU Score"
        else:
            score_name = "CodeBLEU Score"
        
        f.write(f"{score_name}: {result.get('codebleu', result.get('bleu_score', 0)):.4f}\n")
    
    print(f"\n💾 Risultati salvati in: {output_file}")


if __name__ == "__main__":
    main()
