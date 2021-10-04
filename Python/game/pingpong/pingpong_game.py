# importing required library
import turtle

# create screen
screen = turtle.Screen()
screen.title("Pingpong game")
screen.bgcolor("white")
screen.setup(width = 1000, height = 600)

# left paddle
left_pad = turtle.Turtle()
left_pad.speed(0)
left_pad.shape("square")
left_pad.color("black")
left_pad.shapesize(stretch_wid=6,stretch_len=2)
left_pad.penup()
left_pad.goto(-400, 0)

# right paddle
right_pad = turtle.Turtle()
right_pad.speed(0)
right_pad.shape("square")
right_pad.color("black")
right_pad.shapesize(stretch_wid=6,stretch_len=2)
right_pad.penup()
right_pad.goto(400, 0)

# ball
hit_ball = turtle.Turtle()
hit_ball.speed(40)
hit_ball.shape("circle")
hit_ball.color("blue")
hit_ball.penup()
hit_ball.goto(0, 0)
hit_ball.dx = 5
hit_ball.dy = -5

# initialize score
left_player = 0
right_player = 0

# display score
sketch = turtle.Turtle()
sketch.speed(0)
sketch.color("blue")
sketch.penup()
sketch.hideturtle()
sketch.goto(0, 260)
sketch.write("Left player: 0    Right player: 0", align = "center", font = ("Courier", 24, "normal"))

# functions to move pads vertically
def left_pad_up():
    y = left_pad.ycor()
    y += 20
    left_pad.sety(y)

def left_pad_down():
    y = left_pad.ycor()
    y -= 20
    left_pad.sety(y)

def right_pad_up():
    y = right_pad.ycor()
    y += 20
    right_pad.sety(y)

def right_pad_down():
    y = right_pad.ycor()
    y -= 20
    right_pad.sety(y)

# keyboard bindings
screen.listen()
screen.onkeypress(left_pad_up, "w")
screen.onkeypress(left_pad_down, "s")
screen.onkeypress(right_pad_up, "Up")
screen.onkeypress(right_pad_down, "Down")

while True:
    screen.update()

    hit_ball.setx(hit_ball.xcor() + hit_ball.dx)
    hit_ball.sety(hit_ball.ycor() + hit_ball.dy)

    # checking border
    if hit_ball.ycor() > 280:
        hit_ball.sety(280)
        hit_ball.dy *= -1

    if hit_ball.ycor() < -280:
        hit_ball.sety(-280)
        hit_ball.dy *= -1

    if hit_ball.xcor() > 500:
        hit_ball.goto(0, 0)
        hit_ball.dy *= -1
        left_player += 1
        sketch.clear()
        sketch.write("Left player: {}   Right player: {}".format(left_player, right_player), align = "center", font = ("Courier", 24, "normal"))

    # paddles ball collision
    if (hit_ball.xcor() > 360 and hit_ball.xcor() < 370) and (hit_ball.ycor() < right_pad.ycor() + 40 and hit_ball.ycor() > right_pad.ycor() - 40):
        hit_ball.setx(360)
        hit_ball.dx *= -1
    
    if (hit_ball.xcor() < -360 and hit_ball.xcor() > -370) and (hit_ball.ycor() < left_pad.ycor() + 40 and hit_ball.ycor() > left_pad.ycor() - 40):
        hit_ball.setx(-360)
        hit_ball.dx *= -1