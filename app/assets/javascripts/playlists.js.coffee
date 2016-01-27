# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#
window.addToPlaylist = (trackId, playlistId) ->
  $.ajax
    type: 'POST'
    url: "/playlist_tracks"
    data:
      playlist_track:
        track_id: trackId
        playlist_id: playlistId
    success: (data) ->
      console.log('success!')
      #console.log(data)
    error: (data) ->
      console.log('error!')
      #console.log(data)

$('[data-controller=playlists]').ready ->
  $.contextMenu
      selector: '.js-track-context-menu'
      callback: (key, options) ->
        if key == "edit"
          $.get("/tracks/"+$(this).data("track-id")+"/edit/")
        else if key == "delete"
          console.log("delete clicked")
      items:
          "edit": {name: "Edit", icon: "edit"}
          "delete": {name: "Delete", icon: "delete"}
          "sep1": "---------"
          "fold1":
            name: "Add to playlist"
            items:
              window.playlists


  $('.context-menu-one').on 'click', (e) ->
      console.log('clicked', @)

  $('#track-uploader').S3Uploader
    allow_multiple_files: false
    remove_completed_progress_bar: false
    done: (e, data) ->
      console.log("done!")

  $('#track-uploader').on 's3_uploads_start', (e) ->
    console.log("Uploads have started")
    $("#status").html("uploading...")

  $('#track-uploader').on "ajax:success", (e, data) ->
    console.log("server was notified of new file on S3; responded with "+data)
    $("#status").html("complete!")

  $('#track-uploader').on  "ajax:error", (e, data) ->
    $("#status").html("error! :(")
    console.log("there was an error; responded with "+data)

  $(document).on 'click', "ul.playlist-tracks button.delete-from-playlist", () ->
    playlistId = $(this).parent('li').parent('ul').data('playlist-id')
    playlistTrackId = $(this).parent('li').data('playlist-track-id')
    $.ajax
      type: 'DELETE'
      url: "/playlist_tracks/#{playlistTrackId}"
      data:
        playlist_track:
          playlist_id: playlistId
      success: (data) ->
        console.log(data)
      error: (data) ->
        console.log(data)

  $(document).on 'click', '.expand-playlist', () ->
    playlistId = $(this).data('playlist-id')
    $("ul[data-playlist-id=#{playlistId}]").toggle()
