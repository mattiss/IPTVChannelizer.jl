using IPTVChannelizer
using Test

# include("runtests_lexerparser.jl")

@testset "IPTVChannelizer.jl" begin

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
        @test isequal(d["tvg-name"], "##### GENERAL #####")
        @test isequal(d["tvg-logo"], "http://logo.protv.cc/picons/logos/france/FRANCE.png")
        @test isequal(d["group-title"], "|EU| FRANCE HEVC")
    end
    @testset "M3U Parser - Parse attributes \"tvg-id=\"\" tvg-name=\"FR - \"Nosferatu\" - Un film comme un vampire  (2022)\" tvg-logo=\"\" group-title=\"VOD - RÉCEMMENT AJOUTER [FR]\"\"" begin
        d = IPTVChannelizer.parse_attributes("tvg-id=\"\" tvg-name=\"FR - \"Nosferatu\" - Un film comme un vampire  (2022)\" tvg-logo=\"\" group-title=\"VOD - RÉCEMMENT AJOUTER [FR]\"")
        @test_skip isequal(d["tvg-name"], "FR - \"Nosferatu\" - Un film comme un vampire  (2022)")
        @test_skip isequal(d["tvg-logo"], "")
        @test_skip isequal(d["group-title"], "VOD - RÉCEMMENT AJOUTER [FR]")
    end
    @testset "Load Playlist" begin
        m3u_file = "./data/input/playlist_small.m3u"
        playlist = parse_playlist(m3u_file)
        @test isequal(length(playlist), 5) 
        channel = playlist[2]
        # println(channel)
        @test isequal(channel["country"],"FR")
        @test isequal(channel["name"],"TF1")
        @test isequal(channel["res"],"HEVC")
        @test isequal(channel["tvg-id"],"TF1.fr")
        @test isequal(channel["tvg-logo"],"http://logo.protv.cc/picons/logos/france/TF1.png")
        @test isequal(channel["tvg-name"],"FR - TF1 HEVC")
        @test isequal(channel["url"],"http://iptv.provider.fake:80/userid/pwd/845452")
        @test isequal(channel["group-title"],"|EU| FRANCE HEVC")
    end
    @testset "M3U Writer - Print Attributes \"tvg-id=\"\" tvg-name=\"##### GENERAL #####\" tvg-logo=\"http://logo.protv.cc/picons/logos/france/FRANCE.png\" group-title=\"|EU| FRANCE HEVC\"\"" begin
        attributes = NamedTuple{(:name, Symbol("tvg-id"), Symbol("tvg-logo"), Symbol("group-title"), Symbol("tvg-name"), :res, :url, :country), Tuple{String, String, String, String, String, String, String, String}}(("TF1", "TF1.fr", "http://logo.protv.cc/picons/logos/france/TF1.png", "|EU| FRANCE HEVC", "FR - TF1 HEVC", "HEVC", "http://54587-toilet.ott-cdn.me:80/67177f746c/07fb2b2a4e2a/845452", "FR"))  
        @test isequal(IPTVChannelizer.get_attributes(attributes), "tvg-id=\"TF1.fr\" tvg-name=\"FR - TF1 HEVC\" tvg-logo=\"http://logo.protv.cc/picons/logos/france/TF1.png\" group-title=\"|EU| FRANCE HEVC\"")
    end
end
