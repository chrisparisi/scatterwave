json.musics(@musics) do |music|
  json.id music.id
  json.name music.music_file_name
  json.url music.music.url
end