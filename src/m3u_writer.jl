const M3U_FILE_HEADER = "#EXTM3U"

function export_playlist(playlist, m3u_output_file)
    open(m3u_output_file, "w") do file
        println(file, M3U_FILE_HEADER)
        for channel in playlist
            println(file, get_channel_description(channel))            
        end
    end
end

function get_attributes(channel)
    join(["$attribute=\"$(channel[Symbol(attribute)])\"" for attribute in ["tvg-id" "tvg-name" "tvg-logo" "group-title"]]," ")
end

function get_channel_description(channel)
    attr = get_attributes(channel)
    "#EXTINF:-1 $attr,$(channel.name)\n$(channel.url)"
end
