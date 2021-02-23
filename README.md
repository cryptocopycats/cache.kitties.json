# cache.kitties.json - CryptoKitties (Meta) Data in JSON


All meta data one json file at a time.
Naming / filing convention:

The basename of json file is the id (e.g. `1`)
plus the generation (e.g. `0`)
resulting in `1@0`.
For non-normal kitties (exclusive, fancy, etc.)
if there's a ranking it gets add at the end
e.g. (`001431@0_(1)`) is the shipcat fancy
with the id `1431`, generation `0`, and no. `1` in the fancy ranking.


All non-normal kitties (exclusive, fancies, etc.)
get filed in the directories:
- /exclusive
- /fancy
- /shinyfancy
- /special
- /prestige

All the rest, that is, all the normal kitties
get filed in the /normal directory
in blocks of one hundred thousand e.g.:
- /1-99_999
- /100_000-199_999
- /200_000-299_999
- ...

and inside the block again in blocks of one thousand e.g.
- /000
- /001
- /002
- ...



## Data Quirks

### Low Id (< 10000) Kitties

Known 404 Not Found Kitty IDs / Pages (1369 Total).
To verify try `cryptokitties.co/kitty/<id>`
e.g. [`cryptokitties.co/kitty/888`](https://www.cryptokitties.co/kitty/888) resulting in [`cryptokitties.co/404`](https://www.cryptokitties.co/404).


- 130          -- retired Chef Furry exclusive
- 187..200
- 223..230
- 252..259
- 283..302
- 304..385
- 387..395
- 397..401
- 403..500
- 530..531
- 533..542
- 544
- 546..555
- 557..569
- 571..582
- 584..1000      -- incl. 888 retired Golden Dragon Cat exclusive
- 1021..1029
- 1150
- 1503..1801
- 1813..1815
- 1817..1824
- 1879..2000
- 2092
- 2785..3000




