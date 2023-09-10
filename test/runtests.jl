using IPTVChannelizer
using Test

@testset "IPTVChannelizer.jl" begin
    # Write your tests here.
    @testset "M3U Parser - Parse name \"FR - TF1 SD\"" begin
        d = IPTVChannelizer.parse_name("FR - TF1 SD")
        @test isequal(d["name"], "TF1")
        @test isequal(d["country"], "FR")
        @test isequal(d["res"], "SD")
    end
    @testset "M3U Parser - Parse name \"FR - TF1\"" begin
        d = IPTVChannelizer.parse_name("FR - TF1")
        @test isequal(d["name"], "TF1")
        @test isequal(d["country"], "FR")
        @test isequal(d["res"], "UNKNOWN")
    end
    @testset "M3U Parser - Parse attributes \"tvg-id=\"\" tvg-name=\"##### GENERAL #####\" tvg-logo=\"http://logo.protv.cc/picons/logos/france/FRANCE.png\" group-title=\"|EU| FRANCE HEVC\"\"" begin
        d = IPTVChannelizer.parse_attributes("tvg-id=\"\" tvg-name=\"##### GENERAL #####\" tvg-logo=\"http://logo.protv.cc/picons/logos/france/FRANCE.png\" group-title=\"|EU| FRANCE HEVC\"")

    end
    @testset "Load Playlist" begin
        m3u_file = "./data/input/playlist_small.m3u"
        playlist = parse_playlist(m3u_file)
        @test isequal(length(playlist), 5) 
        channel = playlist[2]
        println(channel)
        @test isequal(channel.country,"FR")
        @test isequal(channel.name,"TF1")
        @test isequal(channel.res,"HEVC")
    end
end
