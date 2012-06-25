$(document).ready(function() {
    $('.OMP').each(function() {
        var video = $(this);
        var video_theme = video.attr('theme');
        if(!video_theme) video_theme="sunshine";
        //main wrapper
        var video_wrap = $('<div></div>').addClass('video-player-omp-' + video_theme + ' not-played');
        //controls wraper
        var video_controls = $('<div class="video-controls"><a class="video-play" title="Play/Pause"></a><div class="video-seek"><div class=buffered></div><div class="balloon">00:00</div></div><div class="video-timer">00:00</div><div class="volume-box"><div class="volume-slider"></div><a class="volume-button" title="Mute/Unmute"></a></div><a class="fullscreen-button" title="fullscreen"></a></div>');
        var video_toolbar = $('<div class="toolbar"><a class="light-button" title="light"></a><br/><hr/><a class="expand-button" title="expand"></a></div><div class="mask"></div>');
        video.wrap(video_wrap);
        video.after(video_controls);

        //get new elements
        var video_container = video.parent('.video-player-omp-' + video_theme);
        var video_controls = $('.video-controls', video_container);
        var play_btn = $('.video-play', video_container);
        var video_seek = $('.video-seek', video_container);
        var balloon = $('.balloon', video_container);
        var video_timer = $('.video-timer', video_container);       
        var volume = $('.volume-slider', video_container);
        var volume_btn = $('.volume-button', video_container);
        var fullscreen_btn = $('.fullscreen-button', video_container);
        video_controls.after(video_toolbar);
        var video_toolbar = $('.toolbar', video_container);
        var light_button = $('.light-button', video_container);
        var mask = $('.mask', video_container);

        video_controls.hide(); // keep the controls hidden

        var press_play = function() {
            if(video.attr('paused') == false) {
                video[0].pause();
            } else {
                video[0].play();
            }
        };

        mask.css('height', $(document).height()).hide();

        var seeksliding;
        var createSeek = function() {
            if(video.attr('readyState')) {
                video_duration = video.attr('duration');
                video_seek.slider({
                    value: 0,
                    step: 0.01,
                    orientation: "horizontal",
                    range: "min",
                    max: video_duration,
                animate: true,
                slide: function(){
                        seeksliding = true;
                    },
                    stop:function(e,ui){
                        seeksliding = false;
                        video.attr("currentTime",ui.value);
                    }
                });
            video_controls.show();
            controlsPosition();
            } else {
                setTimeout(createSeek, 150);
            }
        };

        video_seek.mousemove(function(e) {
            balloon.text(gTimeFormat(((video.attr('duration')/video_seek.width()) * e.layerX)));
            balloon.css('left', e.layerX - 16);
        });

        var gTimeFormat=function(seconds){
            var m = seconds / 60 | 0;
            var s = parseInt(seconds % 60);
            return (m > 9 ? '' : '0') + m + ":" + (s > 9 ? '' : '0') + s;
        };

        var controlsPosition = function() {
            var controlsWidth = video_controls[0].clientWidth;
            var videoContainerWidth = video_container[0].clientWidth;
            var controlsLeft = videoContainerWidth/2 - controlsWidth/2;
            video_controls.css({'left': controlsLeft + 'px'});
        };

        var seekUpdate = function() {
            var currenttime = video.attr('currentTime');
            if(!seeksliding) video_seek.slider('value', currenttime);
                video_timer.text(gTimeFormat(currenttime));
        };

        var defineVolumeSensePosition = function() {
            return (video_theme == "sunshine") ? "horizontal" : "vertical";
       };

        volume.slider({
            value: 1,
            orientation: defineVolumeSensePosition(),
            range: "min",
            max: 1, 
            step: 0.05,
            animate: true,
            slide:function(e,ui){
            video.attr('muted',false);
            video_volume = ui.value;
            video.attr('volume',ui.value);
            }
        });

        var muteVolume = function() {
            if(video.attr('muted')==true) {
                video.attr('muted', false);
                volume.slider('value', 1);
            } else {
                video.attr('muted', true);
                volume.slider('value', '0');
                volume_btn.addClass('volume-mute');
            };
        };

        var videoOriginalWidth = video.width();
        var videoOriginalHeight = video.height();
        var fullscreenOn = false;

        var fullscreen = function() {
            if(fullscreenOn){
                video_container.removeClass('fullscreenOn');
                $('body').css('overflow-y', '')
                fullscreenOn = false;
                controlsPosition();
            }
            else
            {
                video_container.addClass('fullscreenOn');
                $('body').css('overflow-y', 'hidden')
                fullscreenOn = true;
                controlsPosition();
            }
        }

        createSeek();
        play_btn.click(press_play);
        video.click(press_play);
        video.dblclick(fullscreen);
        volume_btn.click(muteVolume);
        fullscreen_btn.click(fullscreen);

        video.removeAttr('controls');

        light_button.click(function(){
            mask.toggle();
            if (mask.is(':hidden')) {
                $('body').css('overflow-y', '');
                video_container.removeClass('light-off');
                } else {
                $('body').css('overflow-y', 'hidden');
                video_container.addClass('light-off');
                }
        });

        video.bind('play', function() {
            play_btn.addClass('paused-button');
            video_container.removeClass('not-played');
        });

        video.bind('pause', function() {
            play_btn.removeClass('paused-button');
        });

        video.bind('ended', function() {
            play_btn.removeClass('paused-button');
            video_container.addClass('not-played');
            video.attr("currentTime", 0);
            video[0].pause();
        });

       video.bind('timeupdate', seekUpdate);
       var startBuffer = function() {
           var maxduration = video[0].duration;
           var currentBuffer = video[0].buffered.end(0);
           var percentage = 100 * currentBuffer / maxduration;
           $('.buffered').css('width', percentage+'%');
           if(currentBuffer < maxduration) {
              setTimeout(startBuffer, 100);
           }
        };

        if(video_theme == "sunshine")
        {
            video.bind('loadedmetadata', function (){
                video_timer.after('<div class="video-duration"> &nbsp| ' + gTimeFormat(video.attr('duration')) + '</div>');
                startBuffer();
            });
        }

});
});