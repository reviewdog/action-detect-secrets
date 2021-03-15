#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
import json

rdjson = {
    'source': {
        'name': 'detect-secrets',
        'url': 'https://github.com/Yelp/detect-secrets'
    },
    'severity': 'ERROR',
    'diagnostics': []
}


def main():
    baseline = json.load(sys.stdin)
    if not baseline['results']:
        baseline['results'] = {}

    results = {}
    for detects in baseline['results'].values():
        for item in detects:
            key = '%s:%s' % (item['filename'], item['line_number'])
            if key in results:
                results[key]['message'] += '\n* ' + item['type']
            else:
                results[key] = {
                    'message': '* ' + item['type'],
                    'location': {
                        'path': item['filename'],
                        'range': {
                            'start': {
                                'line': item['line_number']
                            }
                        }
                    }
                }

    for result in results.values():
        rdjson['diagnostics'].append(result)

    try:
        sys.stdout.write(json.dumps(rdjson, indent=2, ensure_ascii=False))
        sys.stdout.write('\n')
    except Exception as error:
        sys.stderr.write('Error: %s\n' % error)
        return 1
    return 0


if __name__ == '__main__':
    sys.exit(main())
