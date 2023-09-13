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
    "#EXTINF:-1 $attr,$(channel.name) $(channel.res)\n$(channel.url)"
end

function print_df(df)
    s = ""
    println(M3U_FILE_HEADER)
    for row in eachrow(df)
        get_channel_description(row["name"], row["group"], row["url"])   
    end
end

#print_df(df_fr)"
function write_channel(f, name, group, url)
    println(f, "#EXTINF:-1 group-title=\"$group\",$name")
    println(f, url)
end

function write_df(output_file, df)
    open(m3u_output_file, "w") do file
        println(file, M3U_FILE_HEADER)
        for row in eachrow(df)
            if !isnothing(row["res"])
                write_channel(file, row["name"]*" "*row["res"], row["group"], row["url"])  
            else
                write_channel(file, row["name"], row["group"], row["url"])  
            end
        end
    end
end


