HealthBar Health1;
Pump Pump1;
Tomb Tomb1;
int money = 500;
int round = 1;
int deadZombs;
boolean gameOver = false;
int overShow = 0;
ArrayList<Bat>bats = new ArrayList<Bat>();
ArrayList<Ghost>ghosts = new ArrayList<Ghost>();
ArrayList<Witch>witchs = new ArrayList<Witch>();
ArrayList<Zomb>zombs = new ArrayList<Zomb>();
void setup() {
  size(640, 360);
  noStroke();
  Pump1 = new Pump();
  Health1 = new HealthBar();
  Tomb1 = new Tomb();
  for (int i = 0; i < 7; i++) {
    bats.add(new Bat());
  }
  for (int i = 0; i < 3; i++) {
    ghosts.add(new Ghost());
  }
  for (int i = 0; i < 1; i++) {
    witchs.add(new Witch());
  }
  newRound();
}

void draw() {
  background(#0700A0);
  fill(#1B8607);
  rectMode(CORNERS);
  rect(0, height - 40, width, height);
  textSize(20);
  fill(255);
  text("£" + money, 20, 20);
  text(round, width-20, 20);
  Pump1.display();
  Health1.display();
  Tomb1.display();
  deadZombs = 0;
  for (int i = 0; i < zombs.size(); i++) {
    if (zombs.get(i).dead == true) {
      deadZombs ++;
    }
    zombs.get(i).display();
    zombs.get(i).walk();
  }
  if (deadZombs == zombs.size()) {
    round ++;
    newRound();
  }
  for (int i = 0; i < bats.size(); i++) {
    bats.get(i).display();
    bats.get(i).fly();
  }
  for (int i = 0; i < ghosts.size(); i++) {
    ghosts.get(i).display();
    ghosts.get(i).walk();
  }
  for (int i = 0; i < witchs.size(); i++) {
    witchs.get(i).display();
    witchs.get(i).fly();
  }
  if (gameOver == true) {
    overShow = 255;
    fill(255, overShow);
    textSize(30);
    text("Game Over", width/2, height/2);
    textSize(15);
    text("Press any button to restart", width/2, height/2 + 40);
  }
}

void keyPressed() {
  if (gameOver == true) {
    Health1.health = 400;
    overShow = 0;
    gameOver = false; 
    money = 500;
    round = 1;
    for (int i = 0; i < zombs.size(); i++) {
      if (zombs.get(i).dead == false) {
        zombs.get(i).dead = true;
        zombs.get(i).x = width + zombs.get(i).d;
        zombs.get(i).y = height - 40;
        zombs.get(i).health = 100 + round * 10;
        zombs.get(i).maxHealth = 100 + round * 10;
      }
    }
    newRound();
  }
}

void mousePressed() {
  if (gameOver == false) {
    for (int i = 0; i < bats.size(); i++) {
      if ((mouseX >= bats.get(i).buttonX - 12.5 && mouseX <= bats.get(i).buttonX + 12.5) && (mouseY >= bats.get(i).buttonY - 17.5 && mouseY <= bats.get(i).buttonY + 17.5)) {
        if (bats.get(i).spawned == false && money >= bats.get(i).cost) {
          bats.get(i).spawn();
          money -= bats.get(i).cost;
          break;
        }
      }
    }
    for (int i = 0; i < ghosts.size(); i++) {
      if ((mouseX >= ghosts.get(i).buttonX - 12.5 && mouseX <= ghosts.get(i).buttonX + 12.5) && (mouseY >= ghosts.get(i).buttonY - 17.5 && mouseY <= ghosts.get(i).buttonY + 17.5)) {
        if (ghosts.get(i).spawned == false && money >= ghosts.get(i).cost) {
          ghosts.get(i).spawn();
          money -= ghosts.get(i).cost;
          break;
        }
      }
    }
    for (int i = 0; i < witchs.size(); i++) {
      if ((mouseX >= witchs.get(i).buttonX - 12.5 && mouseX <= witchs.get(i).buttonX + 12.5) && (mouseY >= witchs.get(i).buttonY - 17.5 && mouseY <= witchs.get(i).buttonY + 17.5)) {
        if (witchs.get(i).spawned == false && money >= witchs.get(i).cost) {
          witchs.get(i).spawn();
          money -= witchs.get(i).cost;
          break;
        }
      }
    }
  }
}

void newRound() {
  for (int i = 0; i < 10 * round; i++) {
    if (i < zombs.size()) {
      zombs.get(i).dead = false;
      zombs.get(i).spell = false;
    } else {
      zombs.add(new Zomb((4*i + 1)*10));
    }
  }
}

void eat() {
  if (Health1.health > 0) {
    Health1.health -= 0.5;
  } else {
    Health1.health = 0;
  }
}

class Witch {
  float x;
  float y;
  float buttonX;
  float buttonY;
  int show;
  int cost = 250;
  float speed = 0.5;
  boolean spawned;
  boolean fly = false;
  float flyS = 0.5;
  float spellX;
  float spellY;
  boolean shoot = false;
  int target;
  Witch() {
    this.x = Tomb1.x;
    this.y = Tomb1.y;
    this.spellX = this.x;
    this.spellY = this.y;
    this.buttonX = width/2 + 40;
    this.buttonY = 20;
    this.show = 0;
  }
  void display() {
    if (this.shoot == false) {
      this.spellX = this.x;
      this.spellY = this.y;
    } else {
      if (zombs.get(target).dead == true) {
        if (target < zombs.size() - 1) {
          target ++;
        } else {
          target = 0;
        }
      }
      if (zombs.get(target).y - 10 > this.spellY) {
        this.spellY += 4;
      }
      if (zombs.get(target).x < this.spellX) {
        this.spellX -= 4;
      } else {
        this.spellX += 4;
      }
      if (this.spellX - 4 <= zombs.get(target).x && this.spellX + 4 >= zombs.get(target).x  && this.spellY - 4 <= zombs.get(target).y - 10 && this.spellY + 4 >= zombs.get(target).y - 10) {
        zombs.get(target).health -= zombs.get(target).maxHealth / 2;
        this.shoot = false;
        this.spellX = this.x;
        this.spellY = this.y;
      }
    }
    fill(255);
    rectMode(CENTER);
    rect(this.buttonX, this.buttonY, 40, 35);
    textSize(15);
    fill(0);
    text("Witch", this.buttonX - 18, this.buttonY);
    text("£" + this.cost, this.buttonX - 15, this.buttonY + 15);
    fill(#ff00ff, this.show);
    rect(this.spellX, this.spellY, 10, 10);
    fill(#7308C1, this.show);
    rect(this.x, this.y - 3, 10, 15); //body
    rect(this.x + 3, this.y + 7, 4, 7);
    rect(this.x + 7, this.y - 5, 10, 4);
    rect(this.x - 7, this.y - 5, 10, 4);
    triangle(this.x - 20, this.y - 30, this.x + 20, this.y - 30, this.x, this.y - 35); //hat
    triangle(this.x - 10, this.y - 30, this.x + 10, this.y - 30, this.x, this.y - 45);
    fill(#C4D3B3, this.show);
    rect(this.x, this.y - 20, 20, 20); //head
    fill(#7C4306, this.show);
    rect(this.x, this.y + 6, 20, 4); //broom
    stroke(#7C4306, this.show);
    line(this.x - 20, this.y, this.x - 10, this.y + 6);
    line(this.x - 20, this.y + 3, this.x - 10, this.y + 6);
    line(this.x - 20, this.y + 6, this.x - 10, this.y + 6);
    line(this.x - 20, this.y + 9, this.x - 10, this.y + 6);
    line(this.x - 20, this.y + 12, this.x - 10, this.y + 6);
    noStroke();
    fill(#7308C1, this.show);
    rect(this.x - 3, this.y + 7, 4, 7); //leg
    fill(0, this.show);
    rect(this.x - 3, this.y - 20, 5, 5);
    rect(this.x + 6, this.y - 20, 5, 5);
  }
  void spawn() {
    this.spawned = true;
    this.show = 255;
  }
  void fly() {
    if (this.spawned == true) {
      if (this.x < width + 30) {
        this.x += this.speed;
      } else {
        this.spawned = false;
        this.x = Tomb1.x;
        this.y = Tomb1.y;
        this.spellX = this.x;
        this.spellY = this.y;
        this.show = 0;
        this.shoot = false;
        this.fly = false;
        for (int i = 0; i < zombs.size(); i++) {
          zombs.get(i).spell = false;
        }
      }
      for (int i = 0; i < zombs.size(); i++) {
        if (zombs.get(i).x < width && zombs.get(i).dead == false && zombs.get(i).spell == false && this.shoot == false && this.fly == true) {
          shoot = true;
          this.target = i;
          zombs.get(i).spell = true;
        }
      }
      if (this.fly == true) {
        this.y += this.flyS;
        if (this.y < 135) {
          this.flyS = -this.flyS;
          this.y += this.flyS;
        }
        if (this.y > 151) {
          this.flyS = -this.flyS;
          this.y += this.flyS;
        }
      }
      if (this.y >= 150 && this.fly == false) {
        this.y --;
      }
      if (this.y < 150) {
        this.fly = true;
      }
    }
  }
}

class Ghost {
  float x;
  float y;
  float buttonX;
  float buttonY;
  int show;
  int cost = 150;
  float speed = 0.25;
  boolean spawned;
  Ghost() {
    this.x = Tomb1.x;
    this.y = Tomb1.y - 5;
    this.buttonX = width/2 - 40;
    this.buttonY = 20;
    this.show = 0;
  }
  void display() {
    fill(255);
    rectMode(CENTER);
    rect(this.buttonX, this.buttonY, 40, 35);
    textSize(15);
    fill(0);
    text("Ghost", this.buttonX - 18, this.buttonY);
    text("£" + this.cost, this.buttonX - 15, this.buttonY + 15);
    stroke(0, this.show);
    fill(255, this.show);
    rect(this.x, this.y - 25, 20, 35);
    rect(this.x + 15, this.y - 25, 15, 5);
    rect(this.x - 5, this.y - 25, 15, 5);
    triangle(this.x - 10, this.y - 7, this.x - 5, this.y - 7, this.x - 7.5, this.y);
    triangle(this.x - 5, this.y - 7, this.x, this.y - 7, this.x - 2.5, this.y);
    triangle(this.x, this.y - 7, this.x + 5, this.y - 7, this.x + 2.5, this.y);
    triangle(this.x + 5, this.y - 7, this.x + 10, this.y - 7, this.x + 7.5, this.y);
    noStroke();
    fill(0, this.show);
    rect(this.x - 4, this.y - 35, 4, 4);
    rect(this.x + 6, this.y - 35, 4, 4);
  }
  void spawn() {
    this.spawned = true;
    this.show = 255;
  }
  void walk() {
    if (this.spawned ==  true) {
      if (this.x < width + 30) {
        this.x += this.speed;
      }
      for (int i = 0; i < zombs.size(); i++) {
        if (this.x - 5 <= zombs.get(i).x && this.x + 5 >= zombs.get(i).x && zombs.get(i).dead == false) {
          zombs.get(i).speed = 0.25;
          zombs.get(i).health -= 1;
        }
      }
    }
  }
}

class Bat {
  float x;
  float y;
  float buttonX;
  float buttonY;
  int show;
  float fly;
  boolean attack;
  int cost = 50;
  boolean spawned = false;
  int target;
  float speed = 0.5;
  Bat() {
    this.x = Tomb1.x;
    this.y = Tomb1.y;
    this.buttonX = width/2;
    this.buttonY = 20;
    this.show = 0;
    this.fly = 1;
  }
  void display() {
    fill(255);
    rectMode(CENTER);
    rect(this.buttonX, this.buttonY, 25, 35);
    textSize(15);
    fill(0);
    text("Bat", this.buttonX - 10, this.buttonY);
    text("£" + this.cost, this.buttonX - 10, this.buttonY + 15);
    fill(0, this.show);
    rect(this.x, this.y - 20, 45, 5);
    triangle(this.x - 22.5, this.y - 22.5, this.x - 17.5, this.y - 22.5, this.x - 25, this.y - 25);
    triangle(this.x - 22.5, this.y - 17.5, this.x - 17.5, this.y - 17.5, this.x - 20, this.y - 10);
    triangle(this.x - 15, this.y - 17.5, this.x - 10, this.y - 17.5, this.x - 12.5, this.y - 7);
    triangle(this.x - 7.5, this.y - 17.5, this.x - 2.5, this.y - 17.5, this.x - 5, this.y - 7);
    triangle(this.x + 7.5, this.y - 17.5, this.x + 2.5, this.y - 17.5, this.x + 5, this.y - 7);
    triangle(this.x + 15, this.y - 17.5, this.x + 10, this.y - 17.5, this.x + 12.5, this.y - 7);
    triangle(this.x + 22.5, this.y - 17.5, this.x + 17.5, this.y - 17.5, this.x + 20, this.y - 10);
    triangle(this.x + 22.5, this.y - 22.5, this.x + 17.5, this.y - 22.5, this.x + 25, this.y - 25);
    triangle(this.x - 5, this.y - 30, this.x, this.y - 30, this.x - 2.5, this.y - 37);
    triangle(this.x + 5, this.y - 30, this.x, this.y - 30, this.x + 2.5, this.y - 37);
    rect(this.x, this.y - 25, 10, 10);
    fill(#ff0000, this.show);
    rect(this.x - 2.5, this.y - 27, 3, 3);
    rect(this.x + 2.5, this.y - 27, 3, 3);
  }
  void spawn() {
    this.spawned = true;
    this.show = 255;
  }
  void fly() {
    if (this.spawned == true) {
      if (this.x <= width + 30) {
        this.x += this.speed;
      } else {
        this.spawned = false;
        this.x = Tomb1.x;
        this.y = Tomb1.y;
        this.buttonX = width/2;
        this.buttonY = 20;
        this.show = 0;
        this.fly = 1;
      }
      this.y += this.fly;
      if (this.y <= 250) {
        this.fly = -this.fly;
        this.y += this.fly;
      } else if (this.y >= 320) {
        this.fly = -this.fly;
        this.y += this.fly;
      }
      for (int i = 0; i < zombs.size(); i++) {
        if (this.x - 15 <= zombs.get(i).x && this.x + 15 >= zombs.get(i).x && zombs.get(i).dead == false) {
          zombs.get(i).health --;
        }
      }
    }
  }
}

class Tomb {
  float x;
  float y;
  Tomb() {
    this.x = 30;
    this.y = height - 40;
  }
  void display() {
    fill(#AAA8A7);
    rectMode(CENTER);
    rect(this.x, this.y - 20, 35, 40);
    circle(this.x, this.y - 35, 30);
  }
}

class HealthBar {
  float x;
  float y;
  float health;
  HealthBar() {
    this.x = width/2;
    this.y = 40;
    this.health = 400;
  }
  void display() {
    if (this.health <= 0) {
      gameOver = true;
    }
    rectMode(CORNER);
    fill(#0000FF);
    rect(this.x - 200, this.y, 400, 20);
    fill(#FF0000);
    rect(this.x - 200, this.y, this.health, 20);
  }
}

class Pump {
  float x;
  float y;
  Pump() {
    this.x = 80;
    this.y = height - 40;
  }
  void display() {
    fill(#0EAA19);
    rectMode(CENTER);
    rect(this.x, this.y - 30, 5, 10);
    rect(this.x + 5, this.y - 35, 5, 5);
    fill(#F77E0C);
    stroke(0);
    ellipse(this.x, this.y - 15, 40, 30);
    ellipse(this.x, this.y - 15, 30, 30);
    ellipse(this.x, this.y - 15, 20, 30);
    line(this.x, this.y, this.x, this.y - 30);
    noStroke();
  }
}

class Zomb {
  float x;
  float y;
  float speed = 0.5;
  float health = 100;
  boolean dead = false;
  boolean dying = false;
  int d;
  float maxHealth = 100;
  boolean spell = false;
  Zomb(int delay) {
    this.d = delay;
    this.x = width + d;
    this.y = height - 40;
  }
  void display() {
    if (this.dead == false) {
      if (this.health <= 0) {
        money += 10;
        this.dead = true;
        this.x = width + this.d;
        this.y = height - 40;
        this.health = 100 + round * 10;
        this.maxHealth = 100 + round * 10;
      } else {
        rectMode(CORNER);
        stroke(0);
        fill(#A07302);
        rect(this.x, this.y - 50, 20, 30);
        fill(#268E04);
        rect(this.x + 2.5, this.y - 65, 15, 15);
        fill(0);
        rect(this.x + 4, this.y - 60, 4, 4);
        rect(this.x + 12, this.y - 60, 4, 4);
        fill(#A07302);
        rect(this.x + 1, this.y - 20, 7, 15);
        rect(this.x + 12, this.y - 20, 7, 15);
        fill(#268E04);
        rect(this.x + 10, this.y - 5, 10, 5);
        rect(this.x - 2, this.y - 5, 10, 5);
        rect(this.x - 15, this.y - 45, 15, 7);
        rect(this.x + 5, this.y - 45, 15, 7);
        noStroke();
        fill(#ff0000);
        rect(this.x, this.y - 75, map(this.health, 0, this.maxHealth, 0, 20), 5);
      }
    }
  }
  void walk() {
    if (this.dead == false) {
      if (this.x <= Pump1.x + 15) {
        eat();
      } else {
        this.x -= this.speed;
      }
    }
  }
}
