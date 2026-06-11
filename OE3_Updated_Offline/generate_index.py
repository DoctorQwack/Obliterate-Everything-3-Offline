import os
import re
import json
import time
import sys

def find_database_files():
    legacy_dir = "Legacy Save Files"
    if not os.path.exists(legacy_dir):
        # Check parent directory
        legacy_dir = os.path.join("..", "Legacy Save Files")
    if not os.path.exists(legacy_dir):
        legacy_dir = "."
    
    files = [f for f in os.listdir(legacy_dir) if f.endswith('.json') and 'PlayerObjects' in f]
    if not files:
        files = [f for f in os.listdir(legacy_dir) if f.endswith('.json') and os.path.getsize(os.path.join(legacy_dir, f)) > 10 * 1024 * 1024]
        
    return [os.path.join(legacy_dir, f) for f in files]

def write_status(status, processed=0, percent=0, error_msg=""):
    data = {
        "status": status,
        "processed": processed,
        "percent": percent,
        "error": error_msg,
        "timestamp": time.time()
    }
    try:
        with open("index_status.json", "w", encoding="utf-8") as f:
            json.dump(data, f)
    except Exception:
        pass

def main():
    try:
        write_status("running", processed=0, percent=0)
        
        db_files = find_database_files()
        if not db_files:
            write_status("error", error_msg="No legacy database JSON file found in 'Legacy Save Files/' folder.")
            return
            
        db_path = db_files[0]
        file_size = os.path.getsize(db_path)
        
        user_pattern = re.compile(r'^\t"([^"]+)"\s*:\s*\{\s*$')
        callsign_pattern = re.compile(r'^\t\t"callsign"\s*:\s*"([^"]+)",?$')
        index_data = []
        
        last_update = time.time()
        processed_count = 0
        
        # Open and scan
        with open(db_path, 'r', encoding='utf-8-sig') as f:
            line_num = 0
            while True:
                line = f.readline()
                if not line:
                    break
                line_num += 1
                
                m = user_pattern.match(line)
                if m:
                    username = m.group(1)
                    
                    # Look ahead for callsign
                    callsign = ""
                    pos = f.tell()
                    for _ in range(15):
                        next_line = f.readline()
                        if not next_line:
                            break
                        m_call = callsign_pattern.match(next_line)
                        if m_call:
                            callsign = m_call.group(1)
                            break
                        if next_line.startswith('\t}') or next_line.startswith('\t"'):
                            break
                    f.seek(pos)
                    
                    index_data.append([username, line_num, callsign])
                    processed_count += 1
                
                # Update status every 0.3 seconds
                now = time.time()
                if now - last_update > 0.3:
                    current_pos = f.tell()
                    percent = int((current_pos / file_size) * 100)
                    write_status("running", processed=processed_count, percent=percent)
                    last_update = now
        
        # Write final index
        with open("legacy_index.json", "w", encoding="utf-8") as out_f:
            json.dump(index_data, out_f)
            
        # Write ready status
        write_status("ready", processed=processed_count, percent=100)
        print(f"Index generation complete. Found {processed_count} users.")
        
    except Exception as e:
        write_status("error", error_msg=str(e))
        print(f"Index generation failed: {e}")

if __name__ == "__main__":
    main()
