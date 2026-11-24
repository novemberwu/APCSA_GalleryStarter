// ============================================================================
// AP CSA (Units 1-3) + AP 2D Art — Virtual Museum Starter Project
// Main Sketch: Teacher Integration, Wall Paintings, 3D Floor Statues & Doorways
// ============================================================================

GalleryEngine engine;

// Student Room Objects (Each team writes one Room class)
Room1_Mythology room1;
Room2_StudentTemplate room2;

// Teacher's Doorway Objects connecting Room 1 <-> Room 2
Doorway room1NorthDoor;
Doorway room2SouthDoor;

// Current active room number (1 or 2)
int currentRoomId = 1;

void settings() {
  size(1440, 900, P3D);
  smooth(4);
}

void setup() {
  surface.setTitle("AP CSA & AP 2D Art — Virtual Gallery Starter (Paintings + 3D Statues)");
  println("[APCSA Gallery] Initializing GalleryEngine...");

  engine = new GalleryEngine(this);

  println("[APCSA Gallery] Loading Room 1 (Mythology, Allegory & Classical Statues)...");
  room1 = new Room1_Mythology(engine);

  println("[APCSA Gallery] Loading Room 2 (Student Template / Sacred Works & Medici Busts)...");
  room2 = new Room2_StudentTemplate(engine);

  room1NorthDoor = new Doorway(
    "NORTH",
    1,
    2,
    room2.getRoomTitle(),
    0.0f,
    470.0f,
    -HALF_PI
  );

  room2SouthDoor = new Doorway(
    "SOUTH",
    2,
    1,
    room1.getRoomTitle(),
    0.0f,
    -470.0f,
    HALF_PI
  );

  println("[APCSA Gallery] Setup complete! Walk near walls for paintings or floor pedestals for 3D statues.");
}

void draw() {
  // 1. Update visitor movement & check wall + statue pedestal collision
  engine.updateCamera(currentRoomId, room1, room2);

  // 2. Begin 3D scene rendering
  engine.begin3DScene();

  Painting activePainting = null;
  Statue activeStatue = null;
  Doorway activeDoorway = null;
  String activeRoomTitle = "";
  String activeCurators = "";
  Statue s1 = null;
  Statue s2 = null;
  GalleryLight currentLight = null;

  // 3. Render current room AND neighbor room through the open see-through Doorway!
  if (currentRoomId == 1) {
    // Draw Room 1 at local (0, 0, 0)
    room1.display(engine);
    room1NorthDoor.display(engine);
    room1.drawSouthEntranceWall(engine);

    // Draw Room 2 physically beyond the open North Doorway (z shifted by -1208)
    // so you can SEE Room 2 through the open archway and walk straight in!
    pushMatrix();
    translate(0, 0, -1208.0f);
    room2.display(engine);
    room2.drawNorthClosedWall(engine);
    popMatrix();

    activePainting = room1.getActivePainting(engine.camX, engine.camZ);
    activeStatue = room1.getActiveStatue(engine.camX, engine.camZ);
    activeRoomTitle = room1.getRoomTitle();
    activeCurators = room1.getCuratorNames();
    s1 = room1.getWestFloorStatue();
    s2 = room1.getEastFloorStatue();
    currentLight = room1.getRoomLight();

    if (room1NorthDoor.isVisitorNearArchway(engine.camX, engine.camZ)) {
      activeDoorway = room1NorthDoor;
    }

    if (room1.isEnteringNorthDoor(engine.camX, engine.camZ) &&
        room1NorthDoor.isVisitorSteppingThrough(engine.camX, engine.camZ)) {
      currentRoomId = room1NorthDoor.getToRoomId();
      // Seamless continuous walk: convert visitor Z from Room 1's North threshold (-562)
      // to Room 2's South threshold (+646 -> +540) without resetting camera look angle!
      engine.seamlessDoorwayStep(engine.camX, 535.0f, "Entered " + room2.getRoomTitle());
    }

  } else if (currentRoomId == 2) {
    // Draw Room 2 at local (0, 0, 0)
    room2.display(engine);
    room2SouthDoor.display(engine);
    room2.drawNorthClosedWall(engine);

    // Draw Room 1 physically beyond the open South Doorway (z shifted by +1208)
    // so you can SEE Room 1 through the open archway and walk straight back!
    pushMatrix();
    translate(0, 0, 1208.0f);
    room1.display(engine);
    room1.drawSouthEntranceWall(engine);
    popMatrix();

    activePainting = room2.getActivePainting(engine.camX, engine.camZ);
    activeStatue = room2.getActiveStatue(engine.camX, engine.camZ);
    activeRoomTitle = room2.getRoomTitle();
    activeCurators = room2.getCuratorNames();
    s1 = room2.getWestFloorStatue();
    s2 = room2.getEastFloorStatue();
    currentLight = room2.getRoomLight();

    if (room2SouthDoor.isVisitorNearArchway(engine.camX, engine.camZ)) {
      activeDoorway = room2SouthDoor;
    }

    if (room2.isEnteringSouthDoor(engine.camX, engine.camZ) &&
        room2SouthDoor.isVisitorSteppingThrough(engine.camX, engine.camZ)) {
      currentRoomId = room2SouthDoor.getToRoomId();
      engine.seamlessDoorwayStep(engine.camX, -535.0f, "Entered " + room1.getRoomTitle());
    }
  }

  // 4. Draw 2D Curator HUD (displays activeStatue if closer, or activePainting)
  engine.drawHUD(currentRoomId, activeRoomTitle, activeCurators, activePainting, activeStatue, activeDoorway, s1, s2, currentLight);
}

void keyPressed() {
  engine.handleKeyPressed(key, keyCode);

  GalleryLight activeLight = (currentRoomId == 1) ? room1.getRoomLight() : room2.getRoomLight();
  if (activeLight != null) {
    if (key == 'l' || key == 'L') {
      activeLight.cyclePreset();
      engine.showToast("Light Preset -> " + activeLight.getFormattedSummary(), 140);
    } else if (key == '[' || key == '-') {
      activeLight.adjustIntensity(-0.05f);
      engine.showToast("Dimmed Light -> " + activeLight.getFormattedSummary(), 110);
    } else if (key == ']' || key == '=' || key == '+') {
      activeLight.adjustIntensity(0.05f);
      engine.showToast("Brightened Light -> " + activeLight.getFormattedSummary(), 110);
    }
  }

  if (key == '1') {
    currentRoomId = 1;
    engine.teleportVisitor(0, 260, -HALF_PI, "Teleported to " + room1.getRoomTitle());
  } else if (key == '2') {
    currentRoomId = 2;
    engine.teleportVisitor(0, 260, -HALF_PI, "Teleported to " + room2.getRoomTitle());
  }
}

void keyReleased() {
  engine.handleKeyReleased(key, keyCode);
}

void mouseDragged() {
  engine.handleMouseDragged();
}
