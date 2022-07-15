var scatterwavePlayer = {},
    scatterwaveAllPlaylists = [],
    scatterwavePlayerID = 'scatterwave_jplayer_main',
    scatterwavePlayerContainer = 'scatterwave_jp_container',
    scatterwavePlaylist,
    currentPlaylistId;

jQuery(document).ready(function($){
    "use strict";

    scatterwavePlayer.init = function(){
        scatterwavePlaylist = new scatterwaveJPlayerPlaylist({
                jPlayer: '#'+scatterwavePlayerID,
                cssSelectorAncestor: "#"+scatterwavePlayerContainer
            },  [
                           ],
            {
                playlistOptions: {
                    enableRemoveControls: true
                },
                swfPath: "/assets/js",
                supplied: "oga, mp3",
                useStateClassSkin: true,
                autoBlur: false,
                smoothPlayBar: false,
                keyEnabled: false,
                audioFullScreen: true,
                display: false,
                autoPlay:false,
            });

        // player loaded event
        $("#"+scatterwavePlayerID).bind($.jPlayer.event.loadeddata, function(event) {
            var Artist = scatterwaveExtractArtistLink($(this).data("jPlayer").status.media.artist),
                Poster = $(this).data("jPlayer").status.media.poster,
                Title = $(this).data("jPlayer").status.media.title;
            $('#'+scatterwavePlayerContainer + ' .current-item .song-poster img').attr('src',Poster);
            $("#"+scatterwavePlayerID).find('img').attr('alt','');
        });

        $(document).on('click','#scatterwave-playlist .playlist-item .song-poster',function(){
            $(this).parent().find('.jp-playlist-item').trigger('click');
        });

        /**
         * event play
         */
        $("#"+scatterwavePlayerID).bind($.jPlayer.event.play + ".jp-repeat", function(event) {

            // poster
            var poster = $(this).data("jPlayer").status.media.poster;
            $('#'+scatterwavePlayerContainer).find('.scatterwave-player .song-poster img').attr('src',poster);

            // blurred background
            $('#'+scatterwavePlayerContainer).find('.blurred-bg').css('background-image','url('+poster+')');


            // astist
            var artist = scatterwaveExtractArtistLink($(this).data("jPlayer").status.media.artist);
            if(artist.name){
                $('#'+scatterwavePlayerContainer+' .artist-name').html('<a href="'+artist.link+'">'+artist.name+'</a>');
            }else{
                $('#'+scatterwavePlayerContainer+' .artist-name').html(artist.name);
            }

            // activate album
            if(typeof currentPlaylistId !== 'undefined'){
                $("[data-album-id='"+currentPlaylistId+"']").addClass('jp-playing');
            }

        });

        $('.scatterwave-mute-control').click(function(){
            var muteControl = $(this);

            if(muteControl.hasClass('muted')){
                var volume = muteControl.attr('data-volume');
                $("#"+scatterwavePlayerID).jPlayer("unmute");
                muteControl.removeClass('muted');
                $("#"+scatterwavePlayerID).jPlayer("volume",volume);
            }else{
                var volume = $("#"+scatterwavePlayerID).data("jPlayer").options.volume;
                muteControl.attr('data-volume',volume);
                $("#"+scatterwavePlayerID).jPlayer("mute").addClass('muted');
                muteControl.addClass('muted');
            }
        });

        /**
         * event pause
         */
        $("#"+scatterwavePlayerID).bind($.jPlayer.event.pause + ".jp-repeat", function(event) {
            // deactivate album
            if(typeof currentPlaylistId !== 'undefined'){
                $("[data-album-id='"+currentPlaylistId+"']").removeClass('jp-playing');
            }
        });

        /**
         * extract artist link from artist string
         * @param str e.g. "Artist name{http://artist.com}"
         * @return return object containing two key link and name
         */
        function scatterwaveExtractArtistLink(str){
            var re  = /{(.*?\})/,
                strRe = str.replace(re,''),
                Match = str.match(re,'')
                ,Link;
            if(Match != null){
                var Link = Match[1].replace('}','');
            }
            return {link:Link,name:strRe};
        }


        /* Modern Seeking */

        var timeDrag = false; /* Drag status */

        $('.jp-progress').mousedown(function (e) {
            timeDrag = true;
            var percentage = updatePercentage(e.pageX,$(this));
            $(this).addClass('dragActive');

            updatebar(percentage);
        });

        $(document).mouseup(function (e) {
            if (timeDrag) {
                timeDrag = false;
                var percentage = updatePercentage(e.pageX,$('.jp-progress.dragActive'));
                $('.jp-progress.dragActive');
                if(percentage){
                    $('.jp-progress.dragActive').removeClass('dragActive');
                    updatebar(percentage);
                }
            }
        });

        $(document).mousemove(function (e) {
            if (timeDrag) {
                var percentage = updatePercentage(e.pageX,$('.jp-progress.dragActive'));
                updatebar(percentage);
            }
        });

        //update Progress Bar control
        var updatebar = function (percentage) {

            var maxduration = $("#"+scatterwavePlayerID).jPlayer.duration; //audio duration

            $('.jp-play-bar').css('width', percentage + '%');

            $("#"+scatterwavePlayerID).jPlayer("playHead", percentage);
            // Update progress bar and video currenttime

            $("#"+scatterwavePlayerID).jPlayer.currentTime = maxduration * percentage / 100;

            return false;
        };


        function updatePercentage(x,progressBar){
            var progress = progressBar;
            var maxduration = $("#"+scatterwavePlayerID).jPlayer.duration; //audio duration
            var position = x - progress.offset().left; //Click pos
            var percentage = 100 * position / progress.width();
            //Check within range
            if (percentage > 100) {
                percentage = 100;
            }
            if (percentage < 0) {
                percentage = 0;
            }
            return percentage;
        }


        var volumeDrag = false;
        $(document).on('mousedown','.jp-volume-bar',function (e) {
            volumeDrag = true;
            updateVolume(e.pageX);
        });

        $(document).mouseup(function (e) {
            if (volumeDrag) {
                volumeDrag = false;
                updateVolume(e.pageX);
            }
        });

        $(document).mousemove(function (e) {
            if (volumeDrag) {
                updateVolume(e.pageX);
            }
        });

        //update Progress Bar control
        var updateVolume = function (x) {
            var progress = $('.jp-volume-bar');
            var position = x - progress.offset().left; //Click pos
            var percentage = 100 * position / progress.width();

            //Check within range
            if (percentage > 100) {
                percentage = 100;
            }
            if (percentage < 0) {
                percentage = 0;
            }
            $("#"+scatterwavePlayerID).jPlayer("volume",(percentage/100));
        };

        // remove track item
        $(document).on('click','.remove-track-item-playlist',function(){
            var parentLi = openMenu.parents('li.item');
            scatterwavePlaylist.remove(parentLi.length-1);
        });

        $(document).on('click','.remove-track-item-current',function(){
            scatterwavePlaylist.remove(scatterwavePlaylist.current);
        });




        /**
         * Function to add track. add track if id not found and return index. If found it return the index
         * @param track track id
         * @returns index number of the track in the playlist
         */
        scatterwavePlayer.addTrack = function(track){
            var _track = tracks[track]
            var foundTrack = false;
            var _return;
            scatterwavePlaylist.playlist.forEach(function(value,index){
                if(value.id == track){
                    foundTrack = true;
                    _return = index;
                }
            });

            if(foundTrack === false){
                scatterwavePlaylist.add(_track);
                _return = scatterwavePlaylist.playlist.length -1;
            }
            return _return;
        }

        /**
         * function to transfer song poster and play button to a larger view. eg. homepage 3 top album listener
         * @param selector
         */
        scatterwavePlayer.transferAlbum = function(selector){
            $(document).on('click',selector,function(e){
                e.preventDefault();
                var PosterTarget = $(this).attr('data-poster-target'),
                    PosterImage = $(this).attr('data-poster'),
                    track = $(this).attr('data-track');

                var PosterClone = $(PosterTarget).clone();
                PosterClone.css('background-image','url('+PosterImage+')').fadeOut(0);
                PosterClone.insertAfter($(PosterTarget));

                $(PosterTarget).fadeOut('slow',function(){
                    $(this).remove();
                });
                PosterClone.fadeIn('slow');
                var Index = scatterwavePlayer.addTrack(track);
                scatterwavePlaylist.play(Index)
            });
        }
        scatterwavePlayer.transferAlbum('.transfer-album');

        //scatterwave album play button
        $(document).on('click','.scatterwave-album-button',function(e){
            var albumId = parseInt($(this).attr('data-album-id'));

            // set play list if not set yet
            if(albumId && typeof scatterwaveAllPlaylists[albumId] !== 'undefined' && currentPlaylistId !== albumId){
                scatterwavePlaylist.setPlaylist(scatterwaveAllPlaylists[albumId]);
                currentPlaylistId = albumId;
            }

            // play or pause
            if($('#'+scatterwavePlayerID).data().jPlayer.status.paused){
                setTimeout(function(){
                    scatterwavePlaylist.play(0);
                },700);
            }else{
                scatterwavePlaylist.pause();
            }

        });

        scatterwavePlayer.addPlaylist = function(albumId){
            if(albumId && typeof scatterwaveAllPlaylists[albumId] !== 'undefined'){
                scatterwaveAllPlaylists[albumId].forEach(function(_value){
                    scatterwavePlaylist.add(_value);
                });
            }
        }

        // init end
    }
});


// document.addEventListener("turbolinks:load", function() {
$(document).ready(function(){
    setTimeout(function(){
        scatterwavePlayer.init();
    },100);

    $(".smart-play").click(function(){
        var $target = $(event.target).data('mid')
        var index = 0;
        scatterwavePlaylist.playlist = [];
        scatterwavePlaylist.original = [];
        $("#player").show();

        $.get('/band_musics/'+$target+'.json', function(response){
            $.each(response.musics, function(idx, obj) {
                scatterwavePlaylist.add({
                    id: obj.id,
                    title: obj.name,
                    mp3: obj.url
                });
                if ($target == obj.id){
                    index = idx
                }
            });
            scatterwavePlaylist.play(index);
        })
    })
});