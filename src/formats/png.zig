// Implement PNG image format according to W3C Portable Network Graphics (PNG) specification second edition (ISO/IEC 15948:2003 (E))
// Last version: https://www.w3.org/TR/PNG/

const std = @import("std");
const types = @import("png/types.zig");
const reader = @import("png/reader.zig");
const color = @import("../color.zig");
const Image = @import("../Image.zig");
const FormatInterface = @import("../format_interface.zig").FormatInterface;
const ImageReadError = Image.ReadError;
const ImageWriteError = Image.WriteError;
const Allocator = std.mem.Allocator;

pub const HeaderData = types.HeaderData;
pub const ColorType = types.ColorType;
pub const CompressionMethod = types.CompressionMethod;
pub const FilterMethod = types.FilterMethod;
pub const FilterType = types.FilterType;
pub const InterlaceMethod = types.InterlaceMethod;
pub const any_chunk_type = reader.any_chunk_type;
pub const any_chunk_type_id = reader.any_chunk_type_id;
pub const isChunkCritical = reader.isChunkCritical;
pub const load = reader.load;
pub const loadHeader = reader.loadHeader;
pub const loadWithHeader = reader.loadWithHeader;
pub const ChunkProcessData = reader.ChunkProcessData;
pub const PaletteProcessData = reader.PaletteProcessData;
pub const RowProcessData = reader.RowProcessData;
pub const ReaderProcessor = reader.ReaderProcessor;
pub const TrnsProcessor = reader.TrnsProcessor;
pub const PlteProcessor = reader.PlteProcessor;
pub const ReaderOptions = reader.ReaderOptions;
pub const DefProcessors = reader.DefProcessors;
pub const DefOptions = reader.DefOptions;
pub const required_temp_bytes = reader.required_temp_bytes;

pub const PNG = struct {
    const Self = @This();

    pub fn init(allocator: Allocator) Self {
        _ = allocator;
        return Self{};
    }

    pub fn formatInterface() FormatInterface {
        return FormatInterface{
            .format = format,
            .formatDetect = formatDetect,
            .readImage = readImage,
            .writeImage = writeImage,
        };
    }

    pub fn format() Image.Format {
        return Image.Format.png;
    }

    pub fn formatDetect(stream: *Image.Stream) ImageReadError!bool {
        var magic_buffer: [types.magic_header.len]u8 = undefined;

        _ = try stream.reader().readAll(magic_buffer[0..]);

        return std.mem.eql(u8, magic_buffer[0..], types.magic_header[0..]);
    }

    pub fn readImage(allocator: Allocator, stream: *Image.Stream) ImageReadError!Image {
        var def_options = DefOptions{};
        return load(stream, allocator, def_options.get());
    }

    pub fn writeImage(allocator: Allocator, write_stream: *Image.Stream, pixels: color.PixelStorage, save_info: Image.SaveInfo) ImageWriteError!void {
        _ = allocator;
        _ = write_stream;
        _ = pixels;
        _ = save_info;
    }
};
