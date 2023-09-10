const REGEX_M3U_FILE_HEADER = r"^#EXTM3U$"
const REGEX_M3U_CHANNEL = r"^#EXTINF:-1 (?<attributes>.*),(?<name>.*)$"
const REGEX_M3U_CHANNEL_NAME = r"^(?<country>.*) - (?<name>.*?)( (?<res>(SD)|(HD)|(FHD)|(HEVC)))?$"
const REGEX_M3U_CHANNEL_ATTRIBUTES = r"^#EXTINF:-1,((?<id>.*):)?"

const M3U_FILE_HEADER = "#EXTM3U"

function parse_playlist(m3u_file)
    channels = []
    open(m3u_file) do file
        header = readline(file)
        if (!occursin(REGEX_M3U_FILE_HEADER, header))
            println("File $(m3u_file) is not a valid m3u file")
        end
        i = 0
        global group = ""
        global id = ""
        global url = ""
        global infos = Dict()
        for ln in eachline(file)
            r = match(REGEX_M3U_CHANNEL, ln)
            if (!isnothing(r))
                infos = Dict()
                attributes, name = r["attributes"], r["name"]
                infos = parse_name(name)
            else
                channel = (country = infos["country"], group = group, id = id, name = infos["name"], res = infos["res"], url=ln)
                push!(channels, channel)
            end
        end
        println("Found $(length(channels)) channels")
        # println(typeof(channels))
        return channels
    end
end

function parse_attributes(att)
    println(att)
end

function parse_name(name)
    r = match(REGEX_M3U_CHANNEL_NAME, name)
    country = "UNKNOWN"
    res = "UNKNOWN"
    if (!isnothing(r))
        if(!isnothing(r["country"])) 
            country = r["country"] 
        end
        if(!isnothing(r["name"])) 
            name = r["name"] 
        end
        if(!isnothing(r["res"])) 
            res = r["res"] 
        end
    end
    return Dict("name" => name, "country" => country, "res" => res)
end

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


