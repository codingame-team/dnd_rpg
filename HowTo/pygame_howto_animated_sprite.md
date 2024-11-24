Pygame does not have a built-in method specifically for handling animated sprites, but it provides the tools to implement them efficiently. You can use the **`pygame.sprite.Sprite`** class along with **`pygame.Surface`** and a sequence of images (frames) to create animated sprites.

Here's a basic example to illustrate how to handle animated sprites in Pygame:

---

### **1. Define an AnimatedSprite Class**

```python
import pygame

class AnimatedSprite(pygame.sprite.Sprite):
    def __init__(self, images, pos, frame_rate=10):
        super().__init__()
        self.images = images  # List of frames
        self.current_frame = 0
        self.image = self.images[self.current_frame]
        self.rect = self.image.get_rect(topleft=pos)
        self.frame_rate = frame_rate  # Frames per second
        self.last_update = pygame.time.get_ticks()

    def update(self):
        now = pygame.time.get_ticks()
        if now - self.last_update > 1000 // self.frame_rate:
            self.last_update = now
            self.current_frame = (self.current_frame + 1) % len(self.images)
            self.image = self.images[self.current_frame]
```

---

### **2. Prepare the Animation Frames**
Load a sequence of images as frames for your animation. You can preload them into a list.

```python
def load_images():
    return [
        pygame.image.load("frame_1.png").convert_alpha(),
        pygame.image.load("frame_2.png").convert_alpha(),
        pygame.image.load("frame_3.png").convert_alpha(),
    ]

frames = load_images()
```

---

### **3. Use the AnimatedSprite in a Game Loop**

```python
pygame.init()
screen = pygame.display.set_mode((800, 600))
clock = pygame.time.Clock()

# Create an animated sprite
sprite_frames = load_images()
animated_sprite = AnimatedSprite(sprite_frames, (100, 100), frame_rate=10)

# Add it to a sprite group
sprites = pygame.sprite.Group()
sprites.add(animated_sprite)

running = True
while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

    # Update and draw sprites
    sprites.update()
    screen.fill((30, 30, 30))  # Clear screen with a dark gray
    sprites.draw(screen)

    pygame.display.flip()
    clock.tick(60)  # Cap the frame rate at 60 FPS

pygame.quit()
```

---

### Key Points
1. **`update()` Method**: Handles the frame switching based on time.
2. **Frame Rate Control**: The `frame_rate` parameter ensures consistent animation speed, regardless of the game's FPS.
3. **Sprite Group**: Use `pygame.sprite.Group` to manage and draw sprites easily.

---

### Advanced Features
To enhance your animation:
- **Dynamic Control**: Add methods to start/stop or change the animation sequence dynamically.
- **Directional Animations**: Use separate frame sequences for different directions.
- **Sprite Sheets**: Load animations from a single sprite sheet by slicing the sheet into individual frames. Use a tool like **`pygame.Surface.subsurface()`** to extract frames programmatically.

By building on this framework, you can create complex animations tailored to your game's requirements.