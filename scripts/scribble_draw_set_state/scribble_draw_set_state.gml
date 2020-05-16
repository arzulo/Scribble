/// @param stateArray   Array of data that will be copied into Scribble's internal draw state
/// 
/// Updates Scribble's current draw state from an array. This function is intended to be used
/// in combination with scribble_draw_get_state().

global.scribble_state_xscale          = argument0[SCRIBBLE_STATE.XSCALE         ];
global.scribble_state_yscale          = argument0[SCRIBBLE_STATE.YSCALE         ];
global.scribble_state_angle           = argument0[SCRIBBLE_STATE.ANGLE          ];
global.scribble_state_colour          = argument0[SCRIBBLE_STATE.COLOUR         ];
global.scribble_state_alpha           = argument0[SCRIBBLE_STATE.ALPHA          ];
global.scribble_state_line_min_height = argument0[SCRIBBLE_STATE.LINE_MIN_HEIGHT];
global.scribble_state_max_width       = argument0[SCRIBBLE_STATE.MAX_WIDTH      ];
global.scribble_state_max_height      = argument0[SCRIBBLE_STATE.MAX_HEIGHT     ];
global.scribble_state_character_wrap  = argument0[SCRIBBLE_STATE.CHARACTER_WRAP ];
global.scribble_state_box_halign      = argument0[SCRIBBLE_STATE.HALIGN         ];
global.scribble_state_box_valign      = argument0[SCRIBBLE_STATE.VALIGN         ];
global.scribble_state_anim_array      = argument0[SCRIBBLE_STATE.ANIMATION_ARRAY];