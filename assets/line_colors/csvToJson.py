import csv
import json

# --- First Pass: Build a map from shortOperatorName to hafasOperatorCode ---
short_to_hafas_map = {}
try:
    with open('line-colors.csv', mode='r', encoding='utf-8') as infile:
        reader = csv.DictReader(infile)
        for row in reader:
            # Store the mapping only if both names are present and the hafas code is not empty
            if row.get('shortOperatorName') and row.get('hafasOperatorCode'):
                short_to_hafas_map[row['shortOperatorName']] = row['hafasOperatorCode']
except FileNotFoundError:
    print("Error: 'line-colors.csv' not found. Make sure the file is in the same directory.")
    exit()

# --- Second Pass: Build the final JSON structure ---
json_data = {}
with open('line-colors.csv', mode='r', encoding='utf-8') as infile:
    reader = csv.DictReader(infile)
    for row in reader:
        hafas_code = row.get('hafasOperatorCode')

        if not hafas_code:
            hafas_code = short_to_hafas_map.get(row.get('shortOperatorName'))

        if not hafas_code:
            continue

        operator_data = json_data.setdefault(hafas_code, {})

        line_details = {
            "background": row.get('backgroundColor').replace("#",""),
            "text": row.get('textColor').replace("#",""),
            "border": row.get('borderColor').replace("#",""),
            "shape": row.get('shape')
        }
        operator_data[row['lineName'].replace(" ","")] = line_details

with open('line_colors.json', 'w', encoding='utf-8') as outfile:
    json.dump(json_data, outfile)
