import os
import re
import json
import time
from datetime import datetime

# Define color codes for a premium terminal look
class Colors:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

def print_header(title):
    print(f"\n{Colors.CYAN}{'='*60}")
    print(f" {Colors.BOLD}{title.center(58)}")
    print(f"{Colors.CYAN}{'='*60}{Colors.ENDC}\n")

def find_database_files():
    legacy_dir = "Legacy Save Files"
    if not os.path.exists(legacy_dir):
        # Fallback to current dir if folder isn't there
        legacy_dir = "."
    
    files = [f for f in os.listdir(legacy_dir) if f.endswith('.json') and 'PlayerObjects' in f]
    # If no specific files, list any large JSON files
    if not files:
        files = [f for f in os.listdir(legacy_dir) if f.endswith('.json') and os.path.getsize(os.path.join(legacy_dir, f)) > 10 * 1024 * 1024]
        
    return [os.path.join(legacy_dir, f) for f in files]

def scan_usernames(db_path, query):
    user_pattern = re.compile(r'^\t"([^"]+)"\s*:\s*\{\s*$')
    matches = []
    count = 0
    t0 = time.time()
    
    print(f"{Colors.YELLOW}Scanning database index for matches...{Colors.ENDC}", end="", flush=True)
    
    with open(db_path, 'r', encoding='utf-8-sig') as f:
        for line_num, line in enumerate(f, 1):
            m = user_pattern.match(line)
            if m:
                username = m.group(1)
                count += 1
                if query.lower() in username.lower():
                    matches.append((username, line_num))
                    
    t1 = time.time()
    print(f"\r{Colors.GREEN}Successfully scanned {count:,} accounts in {t1-t0:.2f} seconds.{Colors.ENDC}")
    return matches

def extract_user_block(file_path, line_num):
    lines = []
    with open(file_path, 'r', encoding='utf-8-sig') as f:
        for i, line in enumerate(f, 1):
            if i < line_num:
                continue
            lines.append(line)
            # Stop when we see the closing brace at the root user indent level
            if line.rstrip().endswith('}') or line.rstrip().endswith('},'):
                if line.startswith('\t}') or line.startswith('}'):
                    break
                    
    full_str = "".join(lines).rstrip()
    if full_str.endswith(','):
        full_str = full_str[:-1]
    
    # Wrap in outer braces to make it valid JSON
    wrapper = "{\n" + full_str + "\n}"
    data = json.loads(wrapper)
    key = list(data.keys())[0]
    return data[key]

def parse_date_to_ms(date_val):
    if not date_val:
        return int(time.time() * 1000)
    if isinstance(date_val, (int, float)):
        return int(date_val)
    if isinstance(date_val, str):
        # Try parsing standard formats
        for fmt in ("%Y-%m-%d %H:%M:%S", "%Y-%m-%dT%H:%M:%S", "%Y-%m-%d"):
            try:
                dt = datetime.strptime(date_val, fmt)
                return int(dt.timestamp() * 1000)
            except ValueError:
                continue
    # Fallback to current time
    return int(time.time() * 1000)

def convert_dict_to_list(data_dict, size, default_val):
    result = []
    if isinstance(data_dict, dict):
        for idx in range(size):
            str_idx = str(idx)
            if str_idx in data_dict:
                val = data_dict[str_idx]
                if isinstance(val, dict):
                    # For nested dict objects like item upgrades {"0": 100, "1": -1...}
                    inner_list = [
                        int(val.get("0", -1)),
                        int(val.get("1", -1)),
                        int(val.get("2", -1)),
                        int(val.get("3", -1))
                    ]
                    result.append(inner_list)
                else:
                    result.append(int(val))
            else:
                result.append(default_val)
    elif isinstance(data_dict, list):
        for idx in range(size):
            if idx < len(data_dict):
                val = data_dict[idx]
                if isinstance(val, list):
                    val = (val + [-1, -1, -1, -1])[:4]
                    result.append([int(x) for x in val])
                elif isinstance(val, dict):
                    inner_list = [
                        int(val.get("0", -1)),
                        int(val.get("1", -1)),
                        int(val.get("2", -1)),
                        int(val.get("3", -1))
                    ]
                    result.append(inner_list)
                else:
                    result.append(int(val))
            else:
                result.append(default_val)
    else:
        result = [default_val for _ in range(size)]
    return result

def convert_to_new_format(legacy_user):
    username = legacy_user.get("username", "GuestPlayer")
    max_inv = int(legacy_user.get("maxinventory", 50))
    
    # 1. Base conversion mapping
    new_user = {
        "username": username,
        "callsign": legacy_user.get("callsign", username),
        "password": legacy_user.get("password", ""),
        "credits": int(legacy_user.get("credits", 500)),
        "stations": int(legacy_user.get("stations", 7)),
        "maxinventory": max_inv,
        "wins": int(legacy_user.get("wins", 0)),
        "losses": int(legacy_user.get("losses", 0)),
        "rating": int(legacy_user.get("rating", 1000)),
        "classlock": int(legacy_user.get("classlock", 0)),
        "dangerClass": int(legacy_user.get("class", legacy_user.get("dangerClass", 0))),
        "campaignseed": int(legacy_user.get("campaignseed", 0)),
        "campaignstart": int(legacy_user.get("campaignstart", -1)),
        "lastbonus": 0, # Reset to 0 so they can immediately claim daily bonus
        "platinum": int(legacy_user.get("platinum", 30))
    }
    
    # 2. Convert string dates to epoch milliseconds
    new_user["lasttime"] = parse_date_to_ms(legacy_user.get("lasttime"))
    new_user["laststations"] = parse_date_to_ms(legacy_user.get("laststations"))
    
    # 3. Convert dict-arrays to proper lists
    new_user["armory"] = convert_dict_to_list(legacy_user.get("armory"), max_inv, [-1, -1, -1, -1])
    new_user["equip"] = convert_dict_to_list(legacy_user.get("equip"), 21, -1)
    new_user["campaign"] = convert_dict_to_list(legacy_user.get("campaign"), 36, 0)
    new_user["prizes"] = convert_dict_to_list(legacy_user.get("prizes"), 36, [-1, -1, -1, -1])
    
    return new_user

def main():
    # Enable ANSI escape characters in Windows command prompt
    os.system("")
    
    print_header("OBLITERATE EVERYTHING 3 - LEGACY SAVE CONVERTER")
    
    # Locate database files
    db_files = find_database_files()
    if not db_files:
        print(f"{Colors.FAIL}Error: No JSON database file found in 'Legacy Save Files' folder.{Colors.ENDC}")
        print(f"Please ensure your legacy database JSON file is placed at:")
        print(f"  Legacy Save Files/oe3_PlayerObjects_Default_*.json\n")
        input("Press Enter to exit...")
        return
        
    # Choose database file if multiple exist
    db_path = db_files[0]
    if len(db_files) > 1:
        print(f"{Colors.CYAN}Multiple database files found:{Colors.ENDC}")
        for idx, f in enumerate(db_files, 1):
            print(f" [{idx}] {os.path.basename(f)} ({os.path.getsize(f) / (1024*1024):.1f} MB)")
        try:
            choice = int(input("\nSelect database index (default 1): ") or 1)
            if 1 <= choice <= len(db_files):
                db_path = db_files[choice - 1]
        except ValueError:
            pass
            
    print(f"{Colors.CYAN}Selected Database: {Colors.BOLD}{os.path.basename(db_path)}{Colors.ENDC}\n")
    
    while True:
        query = input(f"Enter username to search (or 'exit' to quit): ").strip()
        if not query:
            continue
        if query.lower() == 'exit':
            break
            
        # Scan for matches
        matches = scan_usernames(db_path, query)
        
        if not matches:
            print(f"{Colors.FAIL}No accounts found matching '{query}'.{Colors.ENDC}\n")
            continue
            
        # Handle matches
        selected_user = None
        selected_line = -1
        
        if len(matches) == 1:
            selected_user, selected_line = matches[0]
            print(f"\nFound exact match: {Colors.GREEN}{Colors.BOLD}{selected_user}{Colors.ENDC}")
            confirm = input("Convert this save? (y/n, default y): ").strip().lower() or 'y'
            if confirm not in ('y', 'yes'):
                continue
        else:
            print(f"\n{Colors.CYAN}Found multiple matching accounts (capped at 30):{Colors.ENDC}")
            for idx, (username, line_num) in enumerate(matches[:30], 1):
                print(f" [{idx}] {username} (Line {line_num})")
            
            try:
                choice = int(input(f"\nSelect account index (1-{min(len(matches), 30)}): ").strip())
                if 1 <= choice <= min(len(matches), 30):
                    selected_user, selected_line = matches[choice - 1]
                else:
                    print(f"{Colors.FAIL}Invalid selection.{Colors.ENDC}\n")
                    continue
            except ValueError:
                print(f"{Colors.FAIL}Invalid input.{Colors.ENDC}\n")
                continue
                
        # Extract and convert
        print(f"\nExtracting save data for {Colors.BOLD}{selected_user}{Colors.ENDC}...")
        try:
            legacy_user = extract_user_block(db_path, selected_line)
            new_user = convert_to_new_format(legacy_user)
            
            # Destination path
            target_dir = os.path.join("OE3_Updated_Offline", "saves")
            if not os.path.exists(target_dir):
                os.makedirs(target_dir)
                
            # Clean username for filename security
            safe_username = re.sub(r'[^a-zA-Z0-9_\-]', '', selected_user)
            if not safe_username:
                safe_username = "GuestPlayer"
            
            output_file = os.path.join(target_dir, f"save_{safe_username}.json")
            
            with open(output_file, 'w', encoding='utf-8') as out_f:
                json.dump(new_user, out_f, indent=2)
                
            print(f"{Colors.GREEN}{Colors.BOLD}Conversion successful!{Colors.ENDC}")
            print(f"Save file created at: {Colors.CYAN}{output_file}{Colors.ENDC}")
            print(f"\nSummary of converted profile:")
            print(f"  - Callsign:     {new_user['callsign']}")
            print(f"  - Credits:      {new_user['credits']:,}")
            print(f"  - Platinum:     {new_user['platinum']}")
            print(f"  - Rating:       {new_user['rating']}")
            print(f"  - Armory items: {len([x for x in new_user['armory'] if x[0] != -1])}/{new_user['maxinventory']}")
            print(f"  - Campaigns:    {len([x for x in new_user['campaign'] if x != 0])}/36 completed\n")
            
        except Exception as e:
            print(f"{Colors.FAIL}Error converting save data: {e}{Colors.ENDC}\n")
            
    print(f"\n{Colors.GREEN}Thank you for using the Legacy Save Converter!{Colors.ENDC}")
    time.sleep(1.5)

if __name__ == "__main__":
    main()
