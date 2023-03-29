/// Emulation of string_height(), but using Scribble for calculating the width
/// 
/// **Please do not use this function in conjunction with string_copy()**
/// 
/// @param string    The string to draw

function string_height_scribble(_string)
{
    static _scribble_state = __scribble_get_state();
    
    var _font = draw_get_font();
    _font = !font_exists(_font)? _scribble_state.__default_font : font_get_name(_font);
    
    return scribble(_string).font(_font).get_height();
}