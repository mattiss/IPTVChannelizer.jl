
function print_channel(name, group, url)
    println("#EXTINF:-1 group-title=\"$group\",$name $res")
    println(url)
end

function print_df(df)
    s = ""
    println(M3U_FILE_HEADER)
    for row in eachrow(df)
        print_channel(row["name"], row["group"], row["url"])   
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


