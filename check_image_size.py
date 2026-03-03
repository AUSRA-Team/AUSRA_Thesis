
from PIL import Image
import os

images = [
    r"c:\Abdelrhman\Swarm bots GP\Thesis\AUSRA_Thesis\figures\Chapter 1\Project_motivation.png",
    r"c:\Abdelrhman\Swarm bots GP\Thesis\AUSRA_Thesis\figures\Chapter 1\Victim_localization.png"
]

for img_path in images:
    try:
        with Image.open(img_path) as img:
            print(f"Image: {os.path.basename(img_path)}")
            print(f"  Dimensions: {img.size} (Width x Height)")
            print(f"  Aspect Ratio: {img.width / img.height:.2f}")
    except Exception as e:
        print(f"Error reading {img_path}: {e}")
