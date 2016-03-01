boolean outputFlag = false;

int samplingFreq = 20; // データのサンプリング周波数[ms]
int frameRate = 50;
int msPerFrame = 1000 / frameRate; //ex.frameRate=50 20ms
int halfScreenTime = 5000; //画面半分分の時間[ms]
int timePerPixel; // 1pxの時間
int diffPerFrame; // サンプリング周波数を考慮したデータ散布の間隔
int dataMilliTime; // データの時間

boolean playing = true;

String file[] = null;
float[][] data = null;
int columnCount = 4;
int rowCount;

float max;
float min;


void setup(){

   // ファイルの読み込み
   // 1行毎に配列に格納する。
   file = loadStrings("data/sample_walk10s.csv");
   rowCount = file.length;
   dataMilliTime = rowCount*samplingFreq;


   // 2次元配列。data[行][列]
   data = new float[rowCount][columnCount];

   // 最大値と最小値を初期化
   max = float(split(file[0], ",")[1]);
   min = float(split(file[0], ",")[1]);

   // file[]の内容を","で区切って2次元配列に格納
   for(int i=0; i < rowCount; i++){
      String tmp[] = split(file[i], ",");
      for(int j=0; j < tmp.length; j++){
         data[i][j] = float(tmp[j]);
         if (j > 0){
            if (data[i][j] > max){
               max = data[i][j];
            } else if (data[i][j] < min){
               min = data[i][j];
            }
         }
      }
   }

   // 各軸の最大値と最小値を表示
   println("最大値="+max+", 最小値="+min);


   // 出力
   //  for(int i=0; i < file.length; i++){
   //    for(int j=0; j < NUMBER; j++){
   //      print(" " + data[i][j]);
   //    }
   //    println();
   //  }

   // 描画準備
   frameRate(frameRate);                   //20msec毎にグラフを更新
   size(1000, 500);

   timePerPixel = halfScreenTime / (width/2); //ex.halfScreenTime=5000, width=1000 1px:10ms
   diffPerFrame = samplingFreq / timePerPixel; //ex.timePerPixel=10 2px

   println("rowCount = " + rowCount);
}



void draw(){
      background(32);

      // 軸の表示
      stroke( #dddddd );
      strokeWeight( 1 );
      line(0, height/2, width, height/2);
      line(width/2, 0, width/2, height);


      // 線の太さ
      strokeWeight(2);
      noFill();


      // X軸の描画位置の調整
      // int beginPointX;
      // if (frameCount < width/2){
      //    beginPointX = width/2 - frameCount;
      // } else {
      //    beginPointX = 0;
      // }


      // 各軸の処理
      for(int j=1; j<4; j++) {
         // 軸ことに色の指定
         switch(j){
            case 1:
               stroke(255, 0, 0);
               break;
            case 2:
               stroke(0, 255, 0);
               break;
            case 3:
               stroke(0, 0, 255);
               break;
         }
         // 画面全体に描画
         beginShape();
         // int plotX = 0;
         int plotX = width/2 - (frameCount*diffPerFrame);
         for(int i=0; plotX<width+(frameCount*diffPerFrame); i++){
            try{
               if (i >= rowCount-1){
                  // if ( == width+(frameCount*diffPerFrame)-1) noLoop();
                  break;
               }
               vertex(plotX, (-1*height/4)*data[i][j] + height/2);
               plotX += diffPerFrame;
            } catch (ArrayIndexOutOfBoundsException e){
               noLoop();
            }
         }
         endShape();
      }

      // 動画の出力
      if (outputFlag){
         saveFrame("frames/######.tif");
      }

      // 文字の描画
      text("データ時間: "+dataMilliTime+"[ms]", 10, 30);
      text("経過時間: "+msPerFrame*frameCount+"[ms]", 10, 50);
       
      // データ分の時間を再生したら止める
      if (msPerFrame*frameCount >= dataMilliTime) noLoop();
}

void keyPressed() {
   if (key == ' ') {
      if (playing){
         noLoop();
         playing = false;
         println("一時停止");
      }
      else {
         loop();
         playing = true;
         println("再生");
      }
   }
}