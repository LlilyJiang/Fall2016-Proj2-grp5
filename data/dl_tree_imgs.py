#!/usr/bin/env python
import json
import urllib

img_url_prefix = "http://www.cloudred.com/labprojects/nyctrees/trees/"

with open('nyctrees.json', 'r') as f:
    trees = json.loads(f.read())
    for tree in trees:
        if tree['Common'] == 'Horsechestnut':
            tree['Common'] = 'Buckeye'
        tree_img = urllib.URLopener()
        tree_img.retrieve(img_url_prefix + tree['file'], 'imgs/' + tree['Common'] + '.png')
