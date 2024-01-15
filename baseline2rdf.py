#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
import json
import argparse

rdjson = {
    'source': {
        'name': 'detect-secrets',
        'url': 'https://github.com/Yelp/detect-secrets'
    },
    'severity': 'ERROR',
    'diagnostics': []
}


def main(skip_audited: bool = False, verbose: bool = False):
    baseline = json.load(sys.stdin)
    if not baseline['results']:
        baseline['results'] = {}

    results = {}
    for detects in baseline['results'].values():
        for item in detects:
            if skip_audited and 'is_secret' in item and not item['is_secret']:
                if verbose:
                    print('Skipping verified secret in : %s' % item['filename'])
            else:
                key = '%s:%s' % (item['filename'], item['line_number'])
                if key in results:
                    results[key]['message'] += '\n* ' + item['type']
                else:
                    results[key] = {
                        'message': '\n* ' + item['type'],
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
    parser = argparse.ArgumentParser()
    parser.add_argument('--skip-audited', dest='skip_audited', action='store_true')
    parser.add_argument('--no-skip-audited', dest='skip_audited', action='store_false')
    parser.set_defaults(skip_audited=False)
    parser.add_argument('--verbose', dest='verbose', action='store_true')
    parser.set_defaults(verbose=False)
    args = parser.parse_args()

    sys.exit(main(skip_audited=args.skip_audited, verbose=args.verbose))
