import pygame
import random
import sys

# Initialize
pygame.init()

# Screen setup
WIDTH, HEIGHT = 500, 700
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Endless Car Game")

# Colors
WHITE = (255, 255, 255)
GRAY = (50, 50, 50)
RED = (255, 0, 0)
BLUE = (0, 0, 255)

# Clock
clock = pygame.time.Clock()

# Player car
car_width, car_height = 50, 100
player_car = pygame.Rect(WIDTH // 2 - car_width // 2, HEIGHT - 120, car_width, car_height)

# Traffic cars
enemy_cars = []
enemy_speed = 5
spawn_timer = 0

def draw_road():
    screen.fill(GRAY)
    # Draw lane lines
    for y in range(0, HEIGHT, 40):
        pygame.draw.rect(screen, WHITE, (WIDTH // 2 - 5, y, 10, 20))

def draw_car(car_rect, color):
    pygame.draw.rect(screen, color, car_rect, border_radius=5)

def spawn_enemy():
    lane = random.choice([WIDTH // 4 - car_width // 2, WIDTH // 2 - car_width // 2, 3 * WIDTH // 4 - car_width // 2])
    enemy = pygame.Rect(lane, -car_height, car_width, car_height)
    enemy_cars.append(enemy)

def move_enemies():
    for enemy in enemy_cars:
        enemy.y += enemy_speed
    # Remove off-screen enemies
    enemy_cars[:] = [car for car in enemy_cars if car.y < HEIGHT]

def check_collision():
    for enemy in enemy_cars:
        if player_car.colliderect(enemy):
            return True
    return False

# Main game loop
running = True
while running:
    clock.tick(60)
    draw_road()

    # Event handling
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

    # Controls
    keys = pygame.key.get_pressed()
    if keys[pygame.K_LEFT] and player_car.left > 0:
        player_car.x -= 5
    if keys[pygame.K_RIGHT] and player_car.right < WIDTH:
        player_car.x += 5

    # Spawn traffic
    spawn_timer += 1
    if spawn_timer >= 30:
        spawn_enemy()
        spawn_timer = 0

    move_enemies()

    # Draw player and enemies
    draw_car(player_car, BLUE)
    for enemy in enemy_cars:
        draw_car(enemy, RED)

    if check_collision():
        print("💥 Game Over!")
        pygame.quit()
        sys.exit()

    pygame.display.flip()
