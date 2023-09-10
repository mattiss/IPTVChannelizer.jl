module IPTVChannelizer

include("m3u_helper.jl")
export parse_playlist

# Reading the original m3u file
m3u_file = "./test/data/input/playlist.m3u"
channels = parse_playlist(m3u_file)
# https://discourse.julialang.org/t/construct-dataframe-from-uneven-named-tuples/102970

using DataFrames
df = DataFrame(Tables.dictrowtable(channels))
first(df,5)

# m3u_output_file = "/home/jovyan/work/dev/julia/data/m3u/playlist.m3u"
# df_fr = filter(row -> row.country == "FR", df)
# write_df(m3u_output_file, df_fr)

end
