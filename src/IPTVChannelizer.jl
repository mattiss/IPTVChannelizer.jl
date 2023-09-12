module IPTVChannelizer

include("m3u_reader.jl")
export parse_playlist
include("m3u_writer.jl")
export export_playlist


end
