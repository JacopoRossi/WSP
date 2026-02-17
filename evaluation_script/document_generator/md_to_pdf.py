#!/usr/bin/env python3
"""
Script per convertire file Markdown (.md) in PDF.
Utilizza markdown per convertire MD in HTML e weasyprint per generare il PDF.
"""

import sys
import os
from pathlib import Path
import markdown
from weasyprint import HTML, CSS


def convert_md_to_pdf(md_file_path, pdf_file_path=None, css_style=None):
    """
    Converte un file Markdown in PDF.
    
    Args:
        md_file_path (str): Percorso del file Markdown di input
        pdf_file_path (str, optional): Percorso del file PDF di output. 
                                       Se None, usa lo stesso nome del file MD.
        css_style (str, optional): CSS personalizzato per lo stile del PDF
    
    Returns:
        str: Percorso del file PDF generato
    """
    # Verifica che il file MD esista
    if not os.path.exists(md_file_path):
        raise FileNotFoundError(f"File non trovato: {md_file_path}")
    
    # Determina il percorso del PDF di output
    if pdf_file_path is None:
        pdf_file_path = Path(md_file_path).with_suffix('.pdf')
    
    # Leggi il contenuto del file Markdown
    with open(md_file_path, 'r', encoding='utf-8') as f:
        md_content = f.read()
    
    # Converti Markdown in HTML con estensioni
    html_content = markdown.markdown(
        md_content,
        extensions=[
            'extra',          # Tabelle, footnotes, etc.
            'codehilite',     # Syntax highlighting per codice
            'toc',            # Table of contents
            'nl2br',          # New line to break
            'sane_lists'      # Liste migliorate
        ]
    )
    
    # CSS di default per un layout professionale
    default_css = """
        @page {
            size: A4;
            margin: 2cm;
        }
        
        body {
            font-family: 'DejaVu Sans', Arial, sans-serif;
            font-size: 11pt;
            line-height: 1.6;
            color: #333;
        }
        
        h1 {
            color: #2c3e50;
            font-size: 24pt;
            margin-top: 0;
            margin-bottom: 0.5em;
            border-bottom: 2px solid #3498db;
            padding-bottom: 0.3em;
        }
        
        h2 {
            color: #34495e;
            font-size: 20pt;
            margin-top: 1em;
            margin-bottom: 0.5em;
            border-bottom: 1px solid #bdc3c7;
            padding-bottom: 0.2em;
        }
        
        h3 {
            color: #34495e;
            font-size: 16pt;
            margin-top: 0.8em;
            margin-bottom: 0.4em;
        }
        
        h4, h5, h6 {
            color: #555;
            margin-top: 0.6em;
            margin-bottom: 0.3em;
        }
        
        p {
            margin-bottom: 0.8em;
            text-align: justify;
        }
        
        code {
            background-color: #f4f4f4;
            border: 1px solid #ddd;
            border-radius: 3px;
            padding: 2px 5px;
            font-family: 'DejaVu Sans Mono', 'Courier New', monospace;
            font-size: 10pt;
        }
        
        pre {
            background-color: #f8f8f8;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 10px;
            overflow-x: auto;
            margin-bottom: 1em;
        }
        
        pre code {
            background-color: transparent;
            border: none;
            padding: 0;
        }
        
        blockquote {
            border-left: 4px solid #3498db;
            margin-left: 0;
            padding-left: 15px;
            color: #555;
            font-style: italic;
        }
        
        table {
            border-collapse: collapse;
            width: 100%;
            margin-bottom: 1em;
            page-break-inside: auto;
        }
        
        table th, table td {
            border: 1px solid #ddd;
            padding: 6px;
            text-align: left;
            page-break-inside: avoid;
            font-size: 9pt;
        }
        
        table tr {
            page-break-inside: avoid;
            page-break-after: auto;
        }
        
        table th {
            background-color: #3498db;
            color: white;
            font-weight: bold;
            page-break-after: avoid;
        }
        
        table thead {
            display: table-header-group;
        }
        
        table tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        
        ul, ol {
            margin-bottom: 0.8em;
            padding-left: 2em;
        }
        
        li {
            margin-bottom: 0.3em;
        }
        
        a {
            color: #3498db;
            text-decoration: none;
        }
        
        a:hover {
            text-decoration: underline;
        }
        
        img {
            max-width: 100%;
            height: auto;
            display: block;
            margin: 1em auto;
        }
        
        hr {
            border: none;
            border-top: 2px solid #bdc3c7;
            margin: 2em 0;
        }
    """
    
    # Usa il CSS personalizzato se fornito, altrimenti usa quello di default
    css_to_use = css_style if css_style else default_css
    
    # Crea l'HTML completo
    full_html = f"""
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <style>
            {css_to_use}
        </style>
    </head>
    <body>
        {html_content}
    </body>
    </html>
    """
    
    # Genera il PDF
    HTML(string=full_html).write_pdf(pdf_file_path)
    
    return str(pdf_file_path)


def main():
    """Funzione principale per l'uso da linea di comando."""
    if len(sys.argv) < 2:
        print("Uso: python md_to_pdf.py <file.md> [output.pdf]")
        print("\nEsempi:")
        print("  python md_to_pdf.py documento.md")
        print("  python md_to_pdf.py documento.md output.pdf")
        print("  python md_to_pdf.py generated_manuals/48_task_manual.md")
        sys.exit(1)
    
    md_file = sys.argv[1]
    pdf_file = sys.argv[2] if len(sys.argv) > 2 else None
    
    try:
        output_path = convert_md_to_pdf(md_file, pdf_file)
        print(f"✓ PDF generato con successo: {output_path}")
    except Exception as e:
        print(f"✗ Errore durante la conversione: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
