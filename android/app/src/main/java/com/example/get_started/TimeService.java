package com.example.get_started;


import java.util.Timer;
import java.util.TimerTask;
import android.app.Service;
import android.content.Intent;
import android.os.IBinder;

import io.flutter.plugin.common.MethodChannel;

public class TimeService extends Service {

    private final String CHANNEL = "com.example.methodchannel/interop";

    final int INTERVAL_PERIOD = 1000;
    Timer timer = new Timer();
    MethodChannel channel;

    public TimeService() {
    }

    @Override
    public IBinder onBind(Intent intent) {
        // TODO: Return the communication channel to the service.
        throw new UnsupportedOperationException("Not yet implemented");
    }

    @Override
    public void onCreate() {
        super.onCreate();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        sendStatus("onStart");
        timer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                sendStatus("onTick");
            }
        },0,INTERVAL_PERIOD);
        return super.onStartCommand(intent, flags, startId);
    }

    void sendStatus(String message){
        Intent broadcastIntent = new Intent();
        broadcastIntent.putExtra("status",message);
        broadcastIntent.setAction("UPDATE_ACTION");
        getBaseContext().sendBroadcast(broadcastIntent);
    }
}