// ============================================================================
// GalleryEngine.pde — Teacher-Provided 3D & HUD Engine (Paintings + 3D Statues)
// ============================================================================

import java.awt.image.BufferedImage;
import java.io.File;
import java.util.Iterator;
import javax.imageio.ImageIO;
import javax.imageio.ImageReadParam;
import javax.imageio.ImageReader;
import javax.imageio.stream.ImageInputStream;

class GalleryEngine {
  private static final long MAX_OBJ_FILE_BYTES = 20L * 1024L * 1024L;
  private static final int MAX_TEXTURE_DIMENSION = 2560;
  PApplet app;
  PFont uiFont;

  // Visitor camera state
  public float camX = 0.0f;
  public float camY = -15.0f;
  public float camZ = 300.0f;
  public float yaw = -HALF_PI; // Facing North (-Z)
  public float pitch = 0.0f;

  // Movement key flags
  private boolean moveForward = false;
  private boolean moveBackward = false;
  private boolean moveLeft = false;
  private boolean moveRight = false;
  private boolean turnLeft = false;
  private boolean turnRight = false;

  // UI toggles & transition toast banner
  private boolean showCuratorCard = true;
  private boolean showControlsHelp = true;
  private String toastMessage = "";
  private int toastTimer = 0;
  private GalleryLight activeRoomLight = new GalleryLight();

  public GalleryEngine(PApplet app) {
    this.app = app;
    this.uiFont = app.createFont("SansSerif", 18, true);
    app.textFont(this.uiFont);
    app.textureMode(NORMAL);
  }

  // --------------------------------------------------------------------------
  // 1. CAMERA & MOVEMENT CONTROLLER
  // --------------------------------------------------------------------------
  public void updateCamera(int currentRoomId, Room1_Mythology room1, Room2_StudentTemplate room2) {
    float turnSpeed = 0.032f;
    if (turnLeft)  yaw -= turnSpeed;
    if (turnRight) yaw += turnSpeed;

    float moveSpeed = 5.0f;
    float forwardX = cos(yaw);
    float forwardZ = sin(yaw);
    float rightX = cos(yaw + HALF_PI);
    float rightZ = sin(yaw + HALF_PI);

    float dx = 0.0f;
    float dz = 0.0f;
    if (moveForward)  { dx += forwardX * moveSpeed; dz += forwardZ * moveSpeed; }
    if (moveBackward) { dx -= forwardX * moveSpeed; dz -= forwardZ * moveSpeed; }
    if (moveLeft)     { dx -= rightX * moveSpeed;   dz -= rightZ * moveSpeed; }
    if (moveRight)    { dx += rightX * moveSpeed;   dz += rightZ * moveSpeed; }

    float nextX = camX + dx;
    float nextZ = camZ + dz;

    if (currentRoomId == 1) {
      if (room1.canMoveTo(nextX, camZ)) camX = nextX;
      if (room1.canMoveTo(camX, nextZ)) camZ = nextZ;
    } else if (currentRoomId == 2) {
      if (room2.canMoveTo(nextX, camZ)) camX = nextX;
      if (room2.canMoveTo(camX, nextZ)) camZ = nextZ;
    }

    if (toastTimer > 0) {
      toastTimer--;
    }
  }

  public void teleportVisitor(float newX, float newZ, float newYaw, String bannerText) {
    this.camX = newX;
    this.camZ = newZ;
    this.yaw = newYaw;
    this.pitch = 0.0f;
    this.toastMessage = bannerText;
    this.toastTimer = 150;
  }

  // Preserves visitor's exact look angle (yaw & pitch) when walking continuously through an open doorway!
  public void seamlessDoorwayStep(float newX, float newZ, String bannerText) {
    this.camX = newX;
    this.camZ = newZ;
    this.toastMessage = bannerText;
    this.toastTimer = 140;
  }

  public void showToast(String bannerText, int durationFrames) {
    this.toastMessage = bannerText;
    this.toastTimer = durationFrames;
  }

  public void begin3DScene() {
    background(24, 22, 20);
    perspective(PI / 3.0f, (float) width / (float) height, 5.0f, 4500.0f);

    float lookX = camX + cos(yaw) * cos(pitch) * 100.0f;
    float lookY = camY + sin(pitch) * 100.0f;
    float lookZ = camZ + sin(yaw) * cos(pitch) * 100.0f;
    camera(camX, camY, camZ, lookX, lookY, lookZ, 0, 1, 0);

    enableActiveRoomOpenGLLights();
  }

  public void applyRoomLight(GalleryLight light) {
    if (light == null) return;
    this.activeRoomLight = light;
    enableActiveRoomOpenGLLights();
    drawCeilingLightFixture(light);
  }

  private void enableActiveRoomOpenGLLights() {
    noLights();
    GalleryLight light = (this.activeRoomLight != null) ? this.activeRoomLight : new GalleryLight();
    float mult = light.getIntensity();

    lightFalloff(0.85f, 0.0005f, 0.0000003f);
    lightSpecular(0, 0, 0);

    ambientLight(
      constrain(light.getAmbientRed() * mult, 18, 210),
      constrain(light.getAmbientGreen() * mult, 18, 210),
      constrain(light.getAmbientBlue() * mult, 18, 210)
    );
    directionalLight(
      constrain(light.getSpotRed() * 0.45f * mult, 10, 140),
      constrain(light.getSpotGreen() * 0.45f * mult, 10, 140),
      constrain(light.getSpotBlue() * 0.45f * mult, 10, 140),
      0.22f, 0.88f, -0.32f
    );
    pointLight(
      constrain(light.getSpotRed() * 0.72f * mult, 15, 190),
      constrain(light.getSpotGreen() * 0.72f * mult, 15, 190),
      constrain(light.getSpotBlue() * 0.72f * mult, 15, 190),
      light.getLightX(), light.getLightY(), light.getLightZ()
    );
  }

  private void drawCeilingLightFixture(GalleryLight light) {
    pushMatrix();
    translate(light.getLightX(), light.getLightY(), light.getLightZ());
    noStroke();

    fill(78, 60, 34);
    pushMatrix();
    translate(0, -14.0f, 0);
    box(136, 8, 136);
    popMatrix();

    noLights();
    float glow = constrain(light.getIntensity() * 1.15f, 0.35f, 1.0f);
    fill(
      constrain((light.getAmbientRed() + light.getSpotRed()) * 0.65f * glow, 60, 255),
      constrain((light.getAmbientGreen() + light.getSpotGreen()) * 0.65f * glow, 60, 255),
      constrain((light.getAmbientBlue() + light.getSpotBlue()) * 0.65f * glow, 60, 255)
    );
    pushMatrix();
    translate(0, -9.0f, 0);
    box(116, 4, 116);
    popMatrix();
    popMatrix();

    enableActiveRoomOpenGLLights();
  }

  // --------------------------------------------------------------------------
  // 2. ARCHITECTURE & DOORWAY RENDERING
  // --------------------------------------------------------------------------
  public void drawStandardRoomWalls(boolean northDoorOpen, boolean southDoorOpen) {
    float floorY = 130.0f;
    float ceilY = -250.0f;
    float roomH = floorY - ceilY;
    float midY = (floorY + ceilY) * 0.5f;

    noStroke();

    pushMatrix();
    translate(0, floorY + 2, 0);
    fill(146, 94, 72);
    box(1020, 4, 1220);
    popMatrix();

    pushMatrix();
    translate(0, ceilY - 4, 0);
    fill(92, 68, 48);
    box(1020, 8, 1220);
    popMatrix();

    fill(234, 227, 212);
    pushMatrix();
    translate(-504, midY, 0);
    box(8, roomH, 1208);
    popMatrix();

    pushMatrix();
    translate(504, midY, 0);
    box(8, roomH, 1208);
    popMatrix();

    fill(230, 223, 208);
    pushMatrix();
    translate(-297.5f, midY, -604);
    box(405, roomH, 8);
    popMatrix();

    pushMatrix();
    translate(297.5f, midY, -604);
    box(405, roomH, 8);
    popMatrix();

    pushMatrix();
    translate(0, -185.0f, -604);
    box(190, 130, 8);
    popMatrix();

    pushMatrix();
    translate(-297.5f, midY, 604);
    box(405, roomH, 8);
    popMatrix();

    pushMatrix();
    translate(297.5f, midY, 604);
    box(405, roomH, 8);
    popMatrix();

    pushMatrix();
    translate(0, -185.0f, 604);
    box(190, 130, 8);
    popMatrix();

    fill(106, 110, 114);
    pushMatrix(); translate(-498, floorY - 12, 0); box(6, 24, 1200); popMatrix();
    pushMatrix(); translate(498, floorY - 12, 0);  box(6, 24, 1200); popMatrix();
    drawCornerPilaster(-494, -594);
    drawCornerPilaster(494, -594);
    drawCornerPilaster(-494, 594);
    drawCornerPilaster(494, 594);
  }

  private void drawCornerPilaster(float px, float pz) {
    fill(102, 106, 110);
    pushMatrix();
    translate(px, -60, pz);
    box(18, 380, 18);
    popMatrix();
  }

  public void drawCeilingBeam(float zPos) {
    noStroke();
    fill(74, 52, 36);
    pushMatrix();
    translate(0, -242, zPos);
    box(1000, 16, 22);
    popMatrix();

    fill(198, 164, 82);
    pushMatrix();
    translate(0, -233, zPos);
    box(996, 3, 6);
    popMatrix();
  }

  public void drawFloorMedallion(float xPos, float zPos) {
    noStroke();
    fill(112, 114, 116);
    pushMatrix();
    translate(xPos, 129.2f, zPos);
    box(130, 1.5f, 130);
    popMatrix();

    fill(222, 216, 204);
    pushMatrix();
    translate(xPos, 128.6f, zPos);
    box(86, 1.5f, 86);
    popMatrix();

    fill(134, 62, 54);
    pushMatrix();
    translate(xPos, 128.0f, zPos);
    rotateY(QUARTER_PI);
    box(42, 1.5f, 42);
    popMatrix();
  }

  public void drawDoorwayArchOnWall(String wallSide, PImage lintelSign) {
    float zWall = wallSide.equals("NORTH") ? -598.0f : 598.0f;

    noStroke();
    // Pietra Serena Left & Right Doorway Jambs (Opening in center is completely see-through!)
    fill(98, 102, 108);
    pushMatrix();
    translate(-102, 5, zWall);
    box(24, 250, 26);
    popMatrix();

    pushMatrix();
    translate(102, 5, zWall);
    box(24, 250, 26);
    popMatrix();

    // Carved Stone Entablature Lintel above Doorway
    fill(88, 92, 98);
    pushMatrix();
    translate(0, -128, zWall);
    box(236, 26, 30);
    popMatrix();

    // Marble threshold sill on the floor between the two rooms
    fill(196, 190, 178);
    pushMatrix();
    translate(0, 129.0f, zWall);
    box(190, 3, 28);
    popMatrix();

    if (lintelSign != null) {
      float signZ = wallSide.equals("NORTH") ? -582.0f : 582.0f;
      float rotY = wallSide.equals("NORTH") ? 0.0f : PI;
      drawTexturedQuad(lintelSign, 0, -162, signZ, 230, 34, rotY);
    }
  }

  public void drawClosedDoorwayPanel(String wallSide, String label) {
    float zWall = wallSide.equals("NORTH") ? -598.0f : 598.0f;
    noStroke();
    fill(102, 106, 112);
    pushMatrix();
    translate(-102, 5, zWall);
    box(24, 250, 18);
    popMatrix();

    pushMatrix();
    translate(102, 5, zWall);
    box(24, 250, 18);
    popMatrix();

    pushMatrix();
    translate(0, -128, zWall);
    box(236, 24, 22);
    popMatrix();

    fill(198, 190, 176);
    pushMatrix();
    translate(0, 5, zWall);
    box(184, 246, 8);
    popMatrix();
  }

  // --------------------------------------------------------------------------
  // 3. 3D STATUE & PEDESTAL RENDERING (Supports .obj models & marble styles)
  // --------------------------------------------------------------------------
  public void loadNormalizedObjStatue(Statue statue, String objFileName) {
    File f = new File(app.dataPath(objFileName));
    if (!f.exists()) return;
    if (f.length() > MAX_OBJ_FILE_BYTES) {
      long sizeMb = f.length() / (1024L * 1024L);
      String msg = "OBJ " + objFileName + " is " + sizeMb + " MB (>20 MB limit). Using built-in marble style.";
      println("[GalleryEngine] " + msg);
      this.toastMessage = msg;
      this.toastTimer = 260;
      return;
    }
    try {
      PShape shape = app.loadShape(f.getAbsolutePath());
      if (shape == null) return;
      float[] bounds = {
        Float.POSITIVE_INFINITY, Float.POSITIVE_INFINITY, Float.POSITIVE_INFINITY,
        Float.NEGATIVE_INFINITY, Float.NEGATIVE_INFINITY, Float.NEGATIVE_INFINITY
      };
      measureShapeBounds(shape, bounds);
      float largestAxis = max(bounds[3] - bounds[0], max(bounds[4] - bounds[1], bounds[5] - bounds[2]));
      float horizDiam = sqrt(sq(bounds[3] - bounds[0]) + sq(bounds[5] - bounds[2]));
      float normSize = max(largestAxis, horizDiam);
      if (normSize <= 0 || Float.isInfinite(normSize)) return;

      File textureFile = findObjTextureFile(f);
      if (textureFile != null && textureFile.exists()) {
        PImage objTex = loadSafeArtworkImage(textureFile, textureFile.getName());
        if (objTex != null && objTex.width > 0) {
          shape.setStroke(false);
          shape.setTexture(objTex);
          shape.setTint(color(255));
        } else {
          shape.disableStyle();
        }
      } else {
        shape.disableStyle();
      }

      float targetSize = 115.0f;
      float scale = targetSize / normSize;
      float halfH = (bounds[4] - bounds[1]) * scale * 0.5f;
      statue.setNormalizedModel(
        shape,
        (bounds[0] + bounds[3]) * 0.5f,
        (bounds[1] + bounds[4]) * 0.5f,
        (bounds[2] + bounds[5]) * 0.5f,
        scale,
        halfH
      );
    } catch (Exception e) {
      println("[GalleryEngine] Could not load OBJ " + objFileName + ": " + e.getMessage());
    }
  }

  private void measureShapeBounds(PShape shape, float[] bounds) {
    int childCount = shape.getChildCount();
    if (childCount > 0) {
      for (int c = 0; c < childCount; c++) {
        measureShapeBounds(shape.getChild(c), bounds);
      }
      return;
    }
    for (int i = 0; i < shape.getVertexCount(); i++) {
      PVector v = shape.getVertex(i);
      bounds[0] = min(bounds[0], v.x);
      bounds[1] = min(bounds[1], v.y);
      bounds[2] = min(bounds[2], v.z);
      bounds[3] = max(bounds[3], v.x);
      bounds[4] = max(bounds[4], v.y);
      bounds[5] = max(bounds[5], v.z);
    }
  }

  private File findObjTextureFile(File objFile) {
    File dir = objFile.getParentFile();
    if (dir == null) return null;
    String name = objFile.getName();
    String baseName = name.toLowerCase().endsWith(".obj") ? name.substring(0, name.length() - 4) : name;

    File mtlFile = null;
    try {
      String[] lines = loadStrings(objFile.getAbsolutePath());
      if (lines != null) {
        int scanLimit = min(lines.length, 40);
        for (int i = 0; i < scanLimit; i++) {
          String line = lines[i].trim();
          if (line.startsWith("mtllib ")) {
            File candidate = new File(dir, line.substring(7).trim());
            if (candidate.exists()) {
              mtlFile = candidate;
              break;
            }
          }
        }
      }
    } catch (Exception ignored) {
    }
    if (mtlFile == null) {
      File fallbackMtl = new File(dir, baseName + ".mtl");
      if (fallbackMtl.exists()) mtlFile = fallbackMtl;
    }

    if (mtlFile != null) {
      try {
        String[] mtlLines = loadStrings(mtlFile.getAbsolutePath());
        if (mtlLines != null) {
          for (String rawLine : mtlLines) {
            String line = rawLine.trim();
            if (line.startsWith("map_Kd ")) {
              File texCandidate = new File(dir, line.substring(7).trim());
              if (texCandidate.exists()) return texCandidate;
            }
          }
        }
      } catch (Exception ignored) {
      }
    }

    File pngFallback = new File(dir, baseName + ".png");
    if (pngFallback.exists()) return pngFallback;
    File jpgFallback = new File(dir, baseName + ".jpg");
    if (jpgFallback.exists()) return jpgFallback;
    return null;
  }

  public void drawStatueOnPedestal(Statue statue) {
    float floorY = 130.0f;
    float pedHeight = 82.0f;
    float pedTopY = floorY - pedHeight; // y = 48.0f

    pushMatrix();
    translate(statue.getX(), 0, statue.getZ());
    noStroke();

    // 1. Draw Pedestal ("BLOCK", "ROTATING", or "COLUMN")
    String pType = statue.getPedestalType();
    if ("ROTATING".equals(pType)) {
      // Twisted layered Pietra Serena pedestal (just like virtual_exhibition!)
      fill(82, 88, 96);
      int layers = 16;
      float layerH = pedHeight / layers;
      for (int i = 0; i < layers; i++) {
        pushMatrix();
        translate(0, floorY - layerH * 0.5f - i * layerH, 0);
        rotateY(i * PI / 48.0f);
        box(66, layerH + 0.5f, 66);
        popMatrix();
      }
    } else if ("COLUMN".equals(pType)) {
      // Classical Renaissance Column Pedestal
      fill(96, 100, 106);
      pushMatrix(); translate(0, floorY - 8, 0); box(76, 16, 76); popMatrix();
      fill(218, 212, 200);
      for (int a = 0; a < 8; a++) {
        pushMatrix();
        translate(0, floorY - pedHeight * 0.5f, 0);
        rotateY(a * PI / 8.0f);
        box(46, pedHeight - 20, 46);
        popMatrix();
      }
    } else {
      // Classic BLOCK Pedestal
      fill(86, 90, 96);
      pushMatrix(); translate(0, floorY - 7, 0); box(80, 14, 80); popMatrix();
      fill(108, 112, 118);
      pushMatrix(); translate(0, floorY - pedHeight * 0.5f, 0); box(68, pedHeight - 14, 68); popMatrix();
    }

    // Gilded bronze top plate on pedestal
    fill(204, 168, 78);
    pushMatrix();
    translate(0, pedTopY - 2.5f, 0);
    box(78, 5, 78);
    popMatrix();

    // Front brass plaque mounted cleanly in front of the pedestal face
    if (statue.getPlaqueImage() != null) {
      float plaqueZ = "ROTATING".equals(pType) ? 47.5f : 35.5f;
      drawTexturedQuad(statue.getPlaqueImage(), 0, floorY - 46, plaqueZ, 60, 16, 0);
      drawTexturedQuad(statue.getPlaqueImage(), 0, floorY - 46, -plaqueZ, 60, 16, PI);
    }

    // 2. Draw 3D Sculpture on top of the gilded pedestal plate
    float animSeconds = millis() / 1000.0f;
    float rotAngle = radians((animSeconds * statue.getRotatingSpeed()) % 360.0f);

    if (statue.getObjModel() != null) {
      // Render normalized .obj mesh (e.g., statue.obj or vase.obj)
      pushMatrix();
      translate(0, pedTopY - 5.0f - statue.getModelHalfHeight(), 0);
      rotateY(rotAngle);
      float sc = statue.getModelScale();
      scale(sc, -sc, sc);
      translate(-statue.getModelCenterX(), -statue.getModelCenterY(), -statue.getModelCenterZ());
      fill(238, 232, 220); // Carrara marble sheen
      shape(statue.getObjModel());
      popMatrix();
    } else {
      // Render built-in multi-part 3D Renaissance sculpture
      pushMatrix();
      translate(0, pedTopY - 5.0f, 0);
      rotateY(rotAngle);
      drawProceduralStatueStyle(statue.getModelOrStyle());
      popMatrix();
    }

    popMatrix();
  }

  private void drawProceduralStatueStyle(String style) {
    noStroke();
    if ("PORPHYRY_URN".equalsIgnoreCase(style) || "URN".equalsIgnoreCase(style)) {
      // Imperial Red Porphyry & Gold Medici Urn
      fill(204, 168, 78);
      pushMatrix(); translate(0, -6, 0); box(34, 12, 34); popMatrix();
      fill(128, 42, 48);
      pushMatrix(); translate(0, -38, 0); sphereDetail(18); sphere(28); popMatrix();
      fill(204, 168, 78);
      pushMatrix(); translate(0, -68, 0); box(22, 10, 22); popMatrix();
      pushMatrix(); translate(0, -80, 0); sphereDetail(12); sphere(10); popMatrix();
    } else if ("MEDICI_BUST".equalsIgnoreCase(style)) {
      // Carrara Marble Portrait Bust of Lorenzo il Magnifico
      fill(204, 168, 78);
      pushMatrix(); translate(0, -6, 0); box(28, 12, 28); popMatrix();
      fill(242, 238, 228);
      pushMatrix(); translate(0, -24, 0); box(52, 26, 28); popMatrix(); // Draped shoulders
      pushMatrix(); translate(0, -44, 0); box(16, 16, 16); popMatrix(); // Neck
      pushMatrix(); translate(0, -64, 0); sphereDetail(16); sphere(18); popMatrix(); // Sculpted head
      fill(198, 162, 76);
      pushMatrix(); translate(0, -76, 0); box(32, 7, 30); popMatrix(); // Florentine laurel/cap
    } else {
      // Classical Contrapposto Marble Figure (Venus / Apollo)
      fill(242, 238, 230);
      pushMatrix(); translate(0, -5, 0); box(38, 10, 38); popMatrix();
      pushMatrix(); translate(-8, -28, 0); box(11, 38, 11); popMatrix();
      pushMatrix(); translate(8, -28, 3); box(11, 38, 11); popMatrix();
      pushMatrix(); translate(0, -58, 0); box(26, 30, 16); popMatrix();
      pushMatrix(); translate(0, -82, 0); box(32, 24, 18); popMatrix();
      pushMatrix(); translate(-19, -76, 4); rotateZ(0.25f); box(9, 28, 9); popMatrix();
      pushMatrix(); translate(18, -78, 6); rotateZ(-0.35f); box(9, 28, 9); popMatrix();
      pushMatrix(); translate(0, -108, 0); sphereDetail(16); sphere(13); popMatrix();
    }
  }

  public PImage createStatuePreviewThumbnail(String title, String sculptor, String style) {
    int w = 320;
    int h = 240;
    PGraphics pg = app.createGraphics(w, h);
    pg.beginDraw();
    pg.background(34, 32, 30);
    pg.stroke(204, 168, 76);
    pg.strokeWeight(3);
    pg.noFill();
    pg.rect(8, 8, w - 16, h - 16);

    // Draw pedestal & statue silhouette icon
    pg.noStroke();
    pg.fill(102, 106, 112);
    pg.rect(w * 0.5f - 36, h - 74, 72, 54);
    pg.fill(204, 168, 76);
    pg.rect(w * 0.5f - 42, h - 78, 84, 5);

    if (style != null && (style.contains("vase") || style.contains("URN"))) {
      pg.fill(164, 64, 68);
      pg.ellipse(w * 0.5f, h - 118, 64, 72);
      pg.rect(w * 0.5f - 18, h - 162, 36, 16);
    } else {
      pg.fill(240, 234, 222);
      pg.ellipse(w * 0.5f, h - 162, 28, 32);
      pg.rect(w * 0.5f - 22, h - 142, 44, 62, 8);
    }

    pg.fill(242, 222, 168);
    pg.textFont(this.uiFont);
    pg.textAlign(CENTER, TOP);
    pg.textSize(13);
    pg.text("3D FLOOR SCULPTURE (" + style + ")", w * 0.5f, 16);
    pg.endDraw();
    return pg.get();
  }

  // --------------------------------------------------------------------------
  // 4. PAINTING & GOLD FRAME RENDERING
  // --------------------------------------------------------------------------
  public void drawFramedPaintingOnWall(
      PImage canvas,
      PImage plaque,
      String wallSide,
      float x,
      float y,
      float z,
      float w,
      float h,
      boolean isCircularTondo) {

    float rotY = 0.0f;
    float normalX = 0.0f;
    float normalZ = 0.0f;

    if (wallSide.equals("NORTH")) {
      rotY = 0.0f;
      normalZ = 1.0f;
    } else if (wallSide.equals("SOUTH")) {
      rotY = PI;
      normalZ = -1.0f;
    } else if (wallSide.equals("WEST")) {
      rotY = HALF_PI;
      normalX = 1.0f;
    } else if (wallSide.equals("EAST")) {
      rotY = -HALF_PI;
      normalX = -1.0f;
    }

    noStroke();

    pushMatrix();
    translate(x, y, z);
    rotateY(rotY);

    fill(68, 50, 24);
    pushMatrix();
    translate(0, 0, -2.5f);
    box(w + 22, h + 22, 6);
    popMatrix();

    fill(204, 168, 76);
    pushMatrix();
    translate(0, 0, 0.5f);
    box(w + 14, h + 14, 5);
    popMatrix();

    popMatrix();

    float canvasX = x + normalX * 4.2f;
    float canvasZ = z + normalZ * 4.2f;
    drawTexturedQuad(canvas, canvasX, y, canvasZ, w, h, rotY);

    if (plaque != null) {
      float plaqueY = y + h * 0.5f + 26.0f;
      drawTexturedQuad(plaque, canvasX, plaqueY, canvasZ, 128, 30, rotY);
    }
  }

  public void drawTexturedQuad(PImage tex, float x, float y, float z, float w, float h, float rotY) {
    if (tex == null) return;
    GalleryLight light = (this.activeRoomLight != null) ? this.activeRoomLight : new GalleryLight();

    float mixR = light.getAmbientRed() + light.getSpotRed();
    float mixG = light.getAmbientGreen() + light.getSpotGreen();
    float mixB = light.getAmbientBlue() + light.getSpotBlue();
    float maxChannel = max(1.0f, max(mixR, max(mixG, mixB)));

    float exposure = constrain(light.getIntensity() * light.getCanvasExposure() * 1.12f, 0.22f, 1.0f);
    int tintR = int(constrain((mixR / maxChannel) * 255.0f * exposure, 45, 255));
    int tintG = int(constrain((mixG / maxChannel) * 255.0f * exposure, 45, 255));
    int tintB = int(constrain((mixB / maxChannel) * 255.0f * exposure, 45, 255));

    pushMatrix();
    translate(x, y, z);
    rotateY(rotY);
    noLights();
    noStroke();
    fill(tintR, tintG, tintB);
    tint(tintR, tintG, tintB);
    beginShape(QUADS);
    texture(tex);
    normal(0, 0, 1);
    float hw = w * 0.5f;
    float hh = h * 0.5f;
    vertex(-hw, -hh, 0, 0, 0);
    vertex( hw, -hh, 0, 1, 0);
    vertex( hw,  hh, 0, 1, 1);
    vertex(-hw,  hh, 0, 0, 1);
    endShape();
    noTint();
    popMatrix();

    enableActiveRoomOpenGLLights();
  }

  // --------------------------------------------------------------------------
  // 5. SAFE IMAGE LOADING & PROCEDURAL SAMPLE GENERATOR
  // --------------------------------------------------------------------------
  public PImage loadOrCreateArtwork(String imageFileName, String title) {
    File f = new File(app.dataPath(imageFileName));
    if (f.exists()) {
      PImage loaded = loadSafeArtworkImage(f, imageFileName);
      if (loaded != null && loaded.width > 0) {
        return loaded;
      }
    }

    PImage generated = generateSampleArtwork(imageFileName, title);
    try {
      generated.save(app.dataPath(imageFileName));
    } catch (Exception e) {
    }
    return generated;
  }

  private PImage loadSafeArtworkImage(File f, String imageFileName) {
    try (ImageInputStream iis = ImageIO.createImageInputStream(f)) {
      if (iis != null) {
        Iterator<ImageReader> readers = ImageIO.getImageReaders(iis);
        if (readers.hasNext()) {
          ImageReader reader = readers.next();
          try {
            reader.setInput(iis, true, true);
            int rawW = reader.getWidth(0);
            int rawH = reader.getHeight(0);
            int maxDim = Math.max(rawW, rawH);

            if (maxDim > MAX_TEXTURE_DIMENSION) {
              int subsample = Math.max(1, (maxDim + MAX_TEXTURE_DIMENSION - 1) / MAX_TEXTURE_DIMENSION);
              ImageReadParam param = reader.getDefaultReadParam();
              param.setSourceSubsampling(subsample, subsample, 0, 0);
              BufferedImage bimg = reader.read(0, param);
              if (bimg != null) {
                int w = bimg.getWidth();
                int h = bimg.getHeight();
                PImage pimg = app.createImage(w, h, ARGB);
                pimg.loadPixels();
                bimg.getRGB(0, 0, w, h, pimg.pixels, 0, w);
                pimg.updatePixels();
                println("[GalleryEngine] Auto-subsampled oversized artwork " + f.getName() + " from " + rawW + "x" + rawH + " to " + w + "x" + h);
                return pimg;
              }
            }
          } finally {
            reader.dispose();
          }
        }
      }
    } catch (Exception e) {
      println("[GalleryEngine] Subsampling check fallback for " + f.getName() + ": " + e.getMessage());
    }
    return app.loadImage(imageFileName);
  }

  private PImage generateSampleArtwork(String fileName, String title) {
    int w = 520;
    int h = 360;
    PGraphics pg = app.createGraphics(w, h);
    pg.beginDraw();
    pg.smooth(4);
    pg.textFont(this.uiFont);

    if (fileName.equals("primavera.png")) {
      pg.background(28, 46, 32);
      pg.noStroke();
      pg.fill(38, 62, 40);
      pg.rect(0, h * 0.62f, w, h * 0.38f);
      pg.fill(232, 152, 48);
      for (int i = 0; i < 24; i++) {
        pg.ellipse(25 + (i * 21) % (w - 40), 28 + (i * 17) % 75, 9, 9);
      }
      pg.fill(238, 216, 150);
      for (int i = 0; i < 45; i++) {
        pg.ellipse(15 + (i * 37) % (w - 30), h * 0.68f + (i * 19) % 95, 5, 5);
      }
      drawStylizedFigure(pg, w * 0.22f, h * 0.56f, color(242, 232, 212), color(245, 225, 195));
      drawStylizedFigure(pg, w * 0.30f, h * 0.58f, color(242, 232, 212), color(245, 225, 195));
      drawStylizedFigure(pg, w * 0.38f, h * 0.56f, color(242, 232, 212), color(245, 225, 195));
      drawStylizedFigure(pg, w * 0.52f, h * 0.53f, color(182, 54, 48), color(248, 226, 202));
      drawStylizedFigure(pg, w * 0.72f, h * 0.56f, color(236, 224, 192), color(248, 226, 202));
      drawStylizedFigure(pg, w * 0.84f, h * 0.48f, color(112, 154, 178), color(175, 205, 218));

    } else if (fileName.equals("birth_of_venus.png")) {
      pg.background(138, 178, 184);
      pg.noStroke();
      pg.fill(78, 128, 134);
      pg.rect(0, h * 0.54f, w, h * 0.46f);
      pg.fill(232, 198, 124);
      pg.arc(w * 0.50f, h * 0.72f, 150, 75, 0, PI);
      drawStylizedFigure(pg, w * 0.22f, h * 0.42f, color(118, 162, 188), color(225, 205, 188));
      drawStylizedFigure(pg, w * 0.50f, h * 0.52f, color(246, 226, 204), color(230, 178, 92));
      drawStylizedFigure(pg, w * 0.78f, h * 0.54f, color(196, 74, 82), color(242, 220, 196));

    } else if (fileName.equals("pallas_centaur.png")) {
      pg.background(148, 178, 192);
      pg.noStroke();
      pg.fill(122, 108, 86);
      pg.rect(0, 0, w * 0.36f, h * 0.85f);
      pg.fill(164, 148, 118);
      pg.rect(0, h * 0.68f, w, h * 0.32f);
      pg.fill(138, 92, 64);
      pg.rect(w * 0.24f, h * 0.52f, 95, 58, 14);
      drawStylizedFigure(pg, w * 0.36f, h * 0.46f, color(158, 112, 84), color(224, 186, 154));
      drawStylizedFigure(pg, w * 0.64f, h * 0.50f, color(72, 116, 78), color(246, 224, 198));

    } else if (fileName.equals("venus_and_mars.png")) {
      pg.background(56, 74, 52);
      pg.noStroke();
      pg.fill(184, 162, 128);
      pg.rect(0, h * 0.62f, w, h * 0.38f);
      pg.fill(242, 236, 224);
      pg.ellipse(w * 0.28f, h * 0.64f, 170, 62);
      drawStylizedFigure(pg, w * 0.22f, h * 0.52f, color(242, 236, 224), color(232, 188, 98));
      pg.fill(164, 52, 48);
      pg.ellipse(w * 0.72f, h * 0.66f, 175, 58);
      drawStylizedFigure(pg, w * 0.78f, h * 0.54f, color(218, 174, 142), color(140, 95, 62));

    } else if (fileName.equals("adoration_magi.png")) {
      pg.background(136, 172, 202);
      pg.noStroke();
      pg.fill(158, 138, 108);
      pg.rect(w * 0.08f, h * 0.14f, 120, h * 0.58f);
      pg.fill(184, 162, 128);
      pg.rect(0, h * 0.64f, w, h * 0.36f);
      drawStylizedFigure(pg, w * 0.48f, h * 0.40f, color(44, 86, 148), color(246, 224, 198));
      drawStylizedFigure(pg, w * 0.26f, h * 0.58f, color(178, 48, 44), color(236, 206, 178));
      drawStylizedFigure(pg, w * 0.66f, h * 0.58f, color(62, 118, 86), color(236, 206, 178));
      drawStylizedFigure(pg, w * 0.88f, h * 0.56f, color(218, 166, 52), color(242, 212, 184));

    } else if (fileName.equals("madonna_magnificat.png") || fileName.equals("madonna_pomegranate.png")) {
      pg.background(38, 30, 22);
      pg.noStroke();
      pg.fill(204, 168, 76);
      pg.ellipse(w * 0.5f, h * 0.5f, h * 0.94f, h * 0.94f);
      pg.fill(144, 178, 198);
      pg.ellipse(w * 0.5f, h * 0.5f, h * 0.84f, h * 0.84f);
      pg.fill(244, 212, 104);
      pg.arc(w * 0.5f, h * 0.12f, 90, 40, 0, PI);
      drawStylizedFigure(pg, w * 0.34f, h * 0.52f, color(186, 82, 74), color(242, 218, 190));
      drawStylizedFigure(pg, w * 0.50f, h * 0.48f, color(36, 74, 138), color(248, 228, 204));
      drawStylizedFigure(pg, w * 0.66f, h * 0.52f, color(218, 168, 74), color(242, 218, 190));

    } else if (fileName.equals("portrait_medal.png")) {
      pg.background(142, 182, 198);
      pg.noStroke();
      pg.fill(118, 146, 104);
      pg.rect(0, h * 0.54f, w, h * 0.46f);
      drawStylizedFigure(pg, w * 0.50f, h * 0.52f, color(36, 36, 42), color(238, 206, 178));
      pg.fill(186, 44, 42);
      pg.rect(w * 0.42f, h * 0.18f, 84, 28, 6);
      pg.fill(228, 188, 74);
      pg.ellipse(w * 0.52f, h * 0.72f, 52, 52);

    } else {
      pg.background(48, 42, 36);
      pg.stroke(204, 168, 76);
      pg.strokeWeight(4);
      pg.noFill();
      pg.rect(16, 16, w - 32, h - 32);
      pg.fill(242, 224, 178);
      pg.textAlign(CENTER, CENTER);
      pg.textSize(20);
      pg.text(title, w * 0.5f, h * 0.38f);
      pg.fill(190, 182, 166);
      pg.textSize(14);
      pg.text("To display your custom artwork image,\nplace \"" + fileName + "\" inside the sketch's data/ folder.", w * 0.5f, h * 0.62f);
    }

    pg.noStroke();
    pg.fill(22, 18, 15, 165);
    pg.rect(0, h - 28, w, 28);
    pg.fill(236, 218, 174);
    pg.textAlign(CENTER, CENTER);
    pg.textSize(13);
    pg.text(title, w * 0.5f, h - 14);

    pg.endDraw();
    return pg.get();
  }

  private void drawStylizedFigure(PGraphics pg, float cx, float cy, int robeCol, int skinCol) {
    pg.noStroke();
    pg.fill(228, 192, 102, 180);
    pg.ellipse(cx, cy - 58, 38, 38);
    pg.fill(skinCol);
    pg.ellipse(cx, cy - 56, 26, 30);
    pg.fill(robeCol);
    pg.beginShape();
    pg.vertex(cx - 18, cy - 38);
    pg.vertex(cx + 18, cy - 38);
    pg.vertex(cx + 34, cy + 78);
    pg.vertex(cx - 34, cy + 78);
    pg.endShape(CLOSE);
  }

  public PImage createWallPlaqueTexture(String title, String artist, String yearAndMedium) {
    PGraphics pg = app.createGraphics(256, 64);
    pg.beginDraw();
    pg.background(36, 34, 32);
    pg.stroke(188, 158, 86);
    pg.strokeWeight(2);
    pg.noFill();
    pg.rect(2, 2, 252, 60);
    pg.textFont(this.uiFont);
    pg.textAlign(LEFT, TOP);
    pg.fill(242, 226, 184);
    pg.textSize(12);
    String shortTitle = title.length() > 30 ? title.substring(0, 28) + "..." : title;
    pg.text(shortTitle, 10, 8);
    pg.fill(204, 198, 186);
    pg.textSize(10);
    pg.text(artist, 10, 26);
    pg.fill(168, 162, 150);
    pg.text(yearAndMedium, 10, 42);
    pg.endDraw();
    return pg.get();
  }

  public PImage createDoorwaySignTexture(String signText) {
    PGraphics pg = app.createGraphics(460, 68);
    pg.beginDraw();
    pg.background(54, 56, 60);
    pg.stroke(204, 168, 76);
    pg.strokeWeight(3);
    pg.noFill();
    pg.rect(3, 3, 454, 62);
    pg.textFont(this.uiFont);
    pg.textAlign(CENTER, CENTER);
    pg.fill(244, 224, 172);
    pg.textSize(16);
    pg.text(signText, 230, 34);
    pg.endDraw();
    return pg.get();
  }

  // --------------------------------------------------------------------------
  // 6. 2D CURATOR HUD, MINIMAP & DOORWAY OVERLAY (Supports Paintings & Statues)
  // --------------------------------------------------------------------------
  public void drawHUD(
      int currentRoomId,
      String roomTitle,
      String curatorNames,
      Painting activePainting,
      Statue activeStatue,
      Doorway activeDoorway,
      Statue s1,
      Statue s2,
      GalleryLight currentLight) {

    hint(DISABLE_DEPTH_TEST);
    camera();
    ortho();
    noLights();
    textFont(this.uiFont);

    // 1. Top-Left Room Banner
    noStroke();
    fill(20, 18, 16, 225);
    rect(20, 18, 720, 82, 8);
    stroke(198, 164, 82, 180);
    strokeWeight(1.5f);
    noFill();
    rect(20, 18, 720, 82, 8);

    fill(238, 214, 154);
    textAlign(LEFT, TOP);
    textSize(17);
    text(roomTitle, 34, 25);
    fill(192, 186, 174);
    textSize(13);
    text(curatorNames + "   |   Room #" + currentRoomId + " (Walk through Archway or press 1 / 2)", 34, 49);

    String lightSummary = (currentLight != null) ? currentLight.getFormattedSummary() : "Default Warm Light";
    fill(228, 198, 128);
    textSize(12);
    text("Room Light: " + lightSummary + "   (Press [L] Preset, [ / ] Intensity)", 34, 72);

    // 2. Top-Right Local Room Minimap (Shows Paintings, Statues & Doorways!)
    drawRoomMinimap(currentRoomId, s1, s2);

    // 3. Doorway Transition Toast Banner
    if (toastTimer > 0) {
      noStroke();
      fill(28, 24, 20, 235);
      rect(width * 0.5f - 230, 96, 460, 42, 8);
      stroke(218, 182, 88);
      noFill();
      rect(width * 0.5f - 230, 96, 460, 42, 8);
      fill(246, 228, 176);
      textAlign(CENTER, CENTER);
      textSize(15);
      text(toastMessage, width * 0.5f, 117);
    }

    // 4. Doorway Proximity Prompt
    if (activeDoorway != null) {
      noStroke();
      fill(32, 36, 42, 230);
      rect(width * 0.5f - 250, height - 295, 500, 44, 8);
      stroke(204, 168, 76);
      noFill();
      rect(width * 0.5f - 250, height - 295, 500, 44, 8);
      fill(244, 226, 176);
      textAlign(CENTER, CENTER);
      textSize(14);
      text("Walk straight through the " + activeDoorway.getWallSide() + " Archway -> " + activeDoorway.getDestinationTitle(),
           width * 0.5f, height - 273);
    }

    // 5. Active Statue OR Active Painting AP 2D Art FFCC Placard
    if (activeStatue != null) {
      drawExhibitCard(
        activeStatue.getPreviewImage(),
        activeStatue.getFormattedHeader(),
        activeStatue.getFormAndContent(),
        activeStatue.getHistoricalContext(),
        activeStatue.distanceToVisitor(camX, camZ)
      );
    } else if (activePainting != null) {
      drawExhibitCard(
        activePainting.getCanvasImage(),
        activePainting.getFormattedHeader(),
        activePainting.getFormAndContent(),
        activePainting.getHistoricalContext(),
        activePainting.distanceToVisitor(camX, camZ)
      );
    }

    // 6. Bottom Controls Bar
    if (showControlsHelp) {
      noStroke();
      fill(16, 15, 14, 220);
      rect(0, height - 34, width, 34);
      fill(206, 198, 184);
      textAlign(CENTER, CENTER);
      textSize(12);
      text("Move: [W][A][S][D]/Arrows  |  Look: Drag Mouse or [Q]/[E]  |  Light: [L] Preset, [ / ] Dim/Bright  |  Plaque: [I]  |  Rooms: [1]/[2]",
           width * 0.5f, height - 17);
    }

    hint(ENABLE_DEPTH_TEST);
  }

  private void drawExhibitCard(PImage thumb, String header, String formText, String contextText, float distVal) {
    if (showCuratorCard) {
      float cardW = 860;
      float cardH = 195;
      float cardX = (width - cardW) * 0.5f;
      float cardY = height - cardH - 48;

      noStroke();
      fill(18, 16, 14, 235);
      rect(cardX, cardY, cardW, cardH, 10);
      stroke(204, 168, 76);
      strokeWeight(2);
      noFill();
      rect(cardX, cardY, cardW, cardH, 10);

      if (thumb != null) {
        image(thumb, cardX + 18, cardY + 18, 160, 120);
      }

      fill(242, 218, 156);
      textAlign(LEFT, TOP);
      textSize(16);
      text(header, cardX + 196, cardY + 16);

      fill(226, 220, 210);
      textSize(13);
      text(formText, cardX + 196, cardY + 46, cardW - 216, 64);

      fill(188, 208, 194);
      textSize(13);
      text(contextText, cardX + 196, cardY + 114, cardW - 216, 64);

      fill(164, 156, 142);
      textSize(11);
      text("Distance: " + nf(distVal, 0, 0) + " units  |  Press [I] to hide/show plaque", cardX + 18, cardY + 152);
    } else {
      noStroke();
      fill(18, 16, 14, 215);
      rect(width * 0.5f - 230, height - 88, 460, 34, 6);
      fill(242, 218, 156);
      textAlign(CENTER, CENTER);
      textSize(13);
      text("Near: " + header + "  (Press [I] to inspect)", width * 0.5f, height - 71);
    }
  }

  private void drawRoomMinimap(int currentRoomId, Statue s1, Statue s2) {
    float mapW = 150;
    float mapH = 180;
    float mapX = width - mapW - 24;
    float mapY = 20;

    noStroke();
    fill(20, 18, 16, 220);
    rect(mapX - 14, mapY - 12, mapW + 28, mapH + 54, 8);
    stroke(188, 158, 86, 180);
    strokeWeight(1.5f);
    noFill();
    rect(mapX, mapY, mapW, mapH);

    // North & South Doorway Slots on Minimap
    noStroke();
    fill(92, 168, 122);
    rect(mapX + mapW * 0.5f - 16, mapY - 3, 32, 6);
    rect(mapX + mapW * 0.5f - 16, mapY + mapH - 3, 32, 6);

    // 4 Wall Painting Markers (Gold)
    fill(232, 188, 78);
    rect(mapX - 3, mapY + mapH * 0.5f - 12, 6, 24);
    rect(mapX + mapW - 3, mapY + mapH * 0.5f - 12, 6, 24);
    rect(mapX + 20, mapY - 2, 22, 5);
    rect(mapX + mapW - 42, mapY - 2, 22, 5);

    // 2 Floor Statue Pedestal Markers (Cyan Circles)
    stroke(255);
    strokeWeight(1.2f);
    fill(102, 204, 232);
    if (s1 != null) {
      float sx1 = map(s1.getX(), -500, 500, mapX, mapX + mapW);
      float sz1 = map(s1.getZ(), -600, 600, mapY, mapY + mapH);
      ellipse(sx1, sz1, 10, 10);
    }
    if (s2 != null) {
      float sx2 = map(s2.getX(), -500, 500, mapX, mapX + mapW);
      float sz2 = map(s2.getZ(), -600, 600, mapY, mapY + mapH);
      ellipse(sx2, sz2, 10, 10);
    }

    // Visitor Position & View Cone
    float vx = map(camX, -500, 500, mapX, mapX + mapW);
    float vz = map(camZ, -600, 600, mapY, mapY + mapH);
    stroke(248, 224, 132);
    strokeWeight(2);
    line(vx, vz, vx + cos(yaw) * 14, vz + sin(yaw) * 14);
    noStroke();
    fill(255, 96, 76);
    ellipse(vx, vz, 8, 8);

    fill(214, 204, 186);
    textAlign(CENTER, TOP);
    textSize(10);
    text("Room " + currentRoomId + " (Gold=Paint, Cyan=Statue)", mapX + mapW * 0.5f, mapY + mapH + 8);
  }

  // --------------------------------------------------------------------------
  // 7. INPUT HANDLERS
  // --------------------------------------------------------------------------
  public void handleKeyPressed(char k, int code) {
    if (k == 'w' || k == 'W' || code == UP)    moveForward = true;
    if (k == 's' || k == 'S' || code == DOWN)  moveBackward = true;
    if (k == 'a' || k == 'A')                  moveLeft = true;
    if (k == 'd' || k == 'D')                  moveRight = true;
    if (k == 'q' || k == 'Q' || code == LEFT)  turnLeft = true;
    if (k == 'e' || k == 'E' || code == RIGHT) turnRight = true;
    if (k == 'i' || k == 'I')                  showCuratorCard = !showCuratorCard;
    if (k == 'h' || k == 'H')                  showControlsHelp = !showControlsHelp;
  }

  public void handleKeyReleased(char k, int code) {
    if (k == 'w' || k == 'W' || code == UP)    moveForward = false;
    if (k == 's' || k == 'S' || code == DOWN)  moveBackward = false;
    if (k == 'a' || k == 'A')                  moveLeft = false;
    if (k == 'd' || k == 'D')                  moveRight = false;
    if (k == 'q' || k == 'Q' || code == LEFT)  turnLeft = false;
    if (k == 'e' || k == 'E' || code == RIGHT) turnRight = false;
  }

  public void handleMouseDragged() {
    float dx = app.mouseX - app.pmouseX;
    float dy = app.mouseY - app.pmouseY;
    yaw += dx * 0.005f;
    pitch = constrain(pitch + dy * 0.004f, -0.45f, 0.45f);
  }
}
