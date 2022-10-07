# %%
from pathlib import Path
from PIL import Image
import os

path = '.'
for f in Path(path).glob('**/*.png'):
    img = Image.open(f)
    x, y = img.size
    size = int(x*0.6), int(y*0.6)
    img = img.convert('RGB').resize(size)
    img.save(f.with_suffix('.jpeg'), quality=90)
    os.remove(f)
