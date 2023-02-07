/// @param assetName
/// @param friendlyName
/// @param glyphCount
/// @param isSDF

function __scribble_class_font(_asset_name, _friendly_name, _glyph_count, _sdf) constructor
{
    __asset_name = _asset_name;
    __name       = _friendly_name;
    
    
    
    __scribble_font_check_name_conflicts(__name);
    static _font_data_map = __scribble_get_state().__font_data_map;
    _font_data_map[? __name] = self;
    
    
    
    __glyph_data_grid = ds_grid_create(_glyph_count, SCRIBBLE_GLYPH.__SIZE); //We use a grid here to allow us to copy data more quickly during parsing
    __glyphs_map      = ds_map_create(); //We use a map here because our keys are numbers and I don't trust struct performance
    __kerning_map     = ds_map_create(); //We use a map here because our keys are numbers and I don't trust struct performance
    
    __is_krutidev = false;
    
    __sdf           = _sdf;
    __sdf_pxrange   = undefined;
    __superfont     = false;
    __runtime       = false;
    __source_sprite = undefined;
    
    __scale  = 1.0;
    __height = 0; //*Not* the raw height. This value is changed by scribble_font_scale()
    
    __style_regular     = undefined;
    __style_bold        = undefined;
    __style_italic      = undefined;
    __style_bold_italic = undefined;
    
    __font_add_cache = undefined;
    
    //Set in __scribble_font_add_from_file()
    //We use this to reconstruct a font when font_enable_sdf() is called
    __font_add_data = {
        __filename:   undefined,
        __point_size: undefined,
        __bold:       undefined,
        __italic:     undefined,
        __first:      undefined,
        __last:       undefined,
    };
    
     
    
    static __copy_to = function(_target, _copy_styles)
    {
        var _names = variable_struct_get_names(self);
        var _i = 0;
        repeat(array_length(_names))
        {
            var _name = _names[_i];
            if (_name == "__glyphs_map")
            {
                ds_map_copy(_target.__glyphs_map, __glyphs_map);
            }
            else if (_name == "__glyph_data_grid")
            {
                ds_grid_copy(_target.__glyph_data_grid, __glyph_data_grid);
            }
            else if ((_name != "__name") && (_copy_styles || ((_name != "__style_regular") && (_name != "__style_bold") && (_name != "__style_italic") && (_name != "__style_bold_italic"))))
            {
                variable_struct_set(_target, _name, variable_struct_get(self, _name));
            }
            
            ++_i;
        }
    }
    
    static __calculate_font_height = function()
    {
        __height = __glyph_data_grid[# (__glyphs_map[? 32] ?? 0), SCRIBBLE_GLYPH.HEIGHT];
        return __height;
    }
    
    static __clear = function()
    {
        if (!__superfont) __scribble_error("Cannot clear non-superfont fonts");
        
        ds_map_clear(__glyphs_map);
        
        __sdf_pxrange = undefined;
        __sdf         = undefined;
        
        __height = 0;
    }
    
    static __destroy = function()
    {
        if (__SCRIBBLE_DEBUG) __scribble_trace("Destroying font \"", __name, "\"");
        
        ds_map_destroy(__glyphs_map);
        ds_grid_destroy(__glyph_data_grid);
        
        static _font_data_map           = __scribble_get_state().__font_data_map;
        static _font_original_name_dict = __scribble_get_state().__font_original_name_dict;
        
        ds_map_delete(_font_data_map, __name);
        variable_struct_remove(_font_original_name_dict, __asset_name);
        
        if (__source_sprite != undefined)
        {
            sprite_delete(__source_sprite);
            __source_sprite = undefined;
        }
        
        if (__font_add_cache != undefined)
        {
            __font_add_cache.__destroy();
            __font_add_cache = undefined;
        }
    }
}