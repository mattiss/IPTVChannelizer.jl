const REGEX_M3U_FILE_HEADER = r"^#EXTM3U$"
const REGEX_M3U_CHANNEL = r"^#EXTINF:-1 (?<attributes>.*),(?<name>.*)$"
const REGEX_M3U_CHANNEL_NAME = r"^(?<country>.*) - (?<name>.*?)( (?<res>(SD)|(HD)|(FHD)|(UHD)|(HEVC)))?$"
# const REGEX_M3U_CHANNEL_ATTRIBUTES = r"(?<key>.*?)=(\"(?<value>.*?)\") ?"
const REGEX_M3U_CHANNEL_ATTRIBUTES = r"(?<key>tvg-id|tvg-name|tvg-logo|group-title)=(\"(?<value>.*?)\" ?(?=tvg-id|tvg-name|tvg-logo|group-title|\Z))?"


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
                infos = merge(parse_name(name),parse_attributes(attributes))
                # println(infos)
            else
                # channel = (country = infos["country"], group = group, id = id, name = infos["name"], res = infos["res"], url=ln)
                infos["url"] = ln
                push!(channels, infos)
            end
        end
        println("Found $(length(channels)) channels")
        # println(typeof(channels)) 
    end
    return channels
end

function parse_attributes(att)
    return Dict( m["key"] => m["value"] for m in eachmatch(REGEX_M3U_CHANNEL_ATTRIBUTES,att))
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
