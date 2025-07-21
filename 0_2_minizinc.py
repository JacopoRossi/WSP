import minizinc
import sys

def main():
    # Verifica che siano stati forniti almeno i due file principali
    if len(sys.argv) < 3:
        print("Usage: python solver.py <model_file.mzn> <data_file.dzn> [query_time]")
        print("Example: python solver.py 0_modello_ufficiale.mzn 777_space.dzn 100")
        sys.exit(1)
    
    # Ottieni i nomi dei file dai parametri
    mzn_file = sys.argv[1]
    dzn_file = sys.argv[2]
    
    # Se è specificato query_time come terzo parametro
    query_time = None
    if len(sys.argv) >= 4:
        try:
            query_time = int(sys.argv[3])
        except ValueError:
            print(f"Error: query_time must be an integer, got '{sys.argv[3]}'")
            sys.exit(1)
    
    try:
        # Load model and data files
        model = minizinc.Model(mzn_file)
        instance = minizinc.Instance(minizinc.Solver.lookup("gecode"), model)
        
        # Load data from dzn file
        instance.add_file(dzn_file)
        
        # Imposta query_time se specificato
        if query_time is not None:
            instance["query_time"] = query_time
            print(f"Setting query_time = {query_time}")
        else:
            instance["query_time"] = -1
        
        print(f"Loading model: {mzn_file}")
        print(f"Loading data: {dzn_file}")
        print("Solving...")
        
        # Solve
        result = instance.solve()
        print("\nResult:")
        print(result)
        
    except FileNotFoundError as e:
        print(f"Error: File not found - {e}")
        print(f"Make sure both '{mzn_file}' and '{dzn_file}' exist in the current directory")
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()