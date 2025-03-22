# Table Test: Godot MJ -> Initial Tile Draw Process

## Test 1
| player_number | number_of_tiles | pile_wind | pile_max_tiles_per_line | pile_current_pile_draw_position | number_of_tiles_to_draw | pile_total_tiles | remaining_tiles_to_draw | Is Correct? |
|---------------|-----------------|-----------|--------------------------|--------------------------------|------------------------|-----------------|------------------------| -------- |
| 1 | 4 | West | 18 | 11 | 4 | N/A | 0 | Yes |
| 2 | 4 | West | 18 | 13 | 4 | N/A | 0 | Yes |
| 3 | 4 | West | 18 | 15 | 4 | N/A | 0 | Yes |
| 4 | 4 | West | 18 | 17 | 0 | 0 | 4 | **NO** |

## Test 2: With Some Fixes
| player_number | number_of_tiles | pile_wind | pile_max_tiles_per_line | pile_current_pile_draw_position | number_of_tiles_to_draw | pile_total_tiles | remaining_tiles_to_draw | Is Correct? |
|---------------|-----------------|-----------|--------------------------|--------------------------------|------------------------|-----------------|------------------------| -------- |
| 1 | 4 | South | 18 | 14 | 4 | N/A | 0 | Yes |
| 2 | 4 | South | 18 | 16 | 4 | N/A | 0 | Yes |
| 3 | 4 | South | 18 | 18 | 0 | 0 | 4 | Yes |
| 3 | 4 | West | 18 | 1 | 4 | N/A | 0 | Yes |
| 4 | 4 | West | 18 | 3 | 4 | N/A | 0 | Yes |
| 1 | 4 | West | 18 | 5 | 4 | N/A | 0 | Yes |
| 2 | 4 | West | 18 | 7 | 4 | N/A | 0 | Yes |
| 3 | 4 | West | 18 | 9 | 4 | N/A | 0 | Yes |
| 4 | 4 | West | 18 | 11 | 4 | N/A | 0 | Yes |
| 1 | 4 | West | 18 | 13 | 4 | N/A | 0 | Yes |
| 2 | 4 | West | 18 | 15 | 4 | N/A | 0 | Yes |
| 3 | 4 | West | 18 | 17 | 2 | 2 | 2 | Yes |
| 3 | 2 | North | 18 | 1 | 2 | N/A | 0 | Yes |
| 4 | 4 | North | 18 | 2 | 4 | N/A | 0 | Yes |
| 1 | 4 | North | 18 | 4 | 4 | N/A | 0 | Yes |
| 2 | 4 | North | 18 | 6 | 4 | N/A | 0 | Yes |
| 3 | 4 | North | 18 | 8 | 4 | N/A | 0 | Yes |
| 4 | 4 | North | 18 | 10 | 4 | N/A | 0 | Yes |
| 1 | 2 | North | 18 | 12 | 2 | N/A | 0 | Yes |
| 2 | 2 | North | 18 | 13 | 2 | N/A | 0 | Yes |
| 3 | 2 | North | 18 | 14 | 2 | N/A | 0 | Yes |
| 4 | 2 | North | 18 | 15 | 2 | N/A | 0 | Yes |
| 1 | 2 | North | 18 | 16 | 2 | N/A | 0 | Yes |
| 2 | 2 | North | 18 | 17 | 2 | N/A | 0 | Yes |
| 3 | 2 | North | 18 | 18 | 0 | 0 | 2 | Yes |
| 3 | 2 | East | 18 | 1 | 2 | N/A | 0 | Yes |
| 4 | 2 | East | 18 | 2 | 2 | N/A | 0 | Yes |
| 1 | 2 | East | 18 | 3 | 2 | N/A | 0 | Yes |
| 2 | 2 | East | 18 | 4 | 2 | N/A | 0 | Yes |
| 3 | 2 | East | 18 | 5 | 2 | N/A | 0 | Yes |
| 4 | 2 | East | 18 | 6 | 2 | N/A | 0 | Yes |
| 1 | 2 | East | 18 | 7 | 2 | N/A | 0 | Yes |
| 2 | 2 | East | 18 | 8 | 2 | N/A | 0 | Yes |
| 3 | 2 | East | 18 | 9 | 2 | N/A | 0 | Yes |
| 4 | 2 | East | 18 | 10 | 2 | N/A | 0 | Yes |
| 1 | 2 | East | 18 | 11 | 2 | N/A | 0 | Yes |
| 2 | 2 | East | 18 | 12 | 2 | N/A | 0 | Yes |
| 3 | 2 | East | 18 | 13 | 2 | N/A | 0 | Yes |
| 4 | 2 | East | 18 | 14 | 2 | N/A | 0 | Yes |
| 1 | 2 | East | 18 | 15 | 2 | N/A | 0 | Yes |
| 2 | 2 | East | 18 | 16 | 2 | N/A | 0 | Yes |
| 3 | 2 | East | 18 | 17 | 2 | N/A | 0 | Yes |
| 4 | 2 | East | 18 | 18 | 0 | 0 | 2 | Yes |
| 4 | 2 | South | 18 | 18 | 0 | 0 | 2 | **NO** |
| 4 | 2 | West | 18 | 18 | 0 | 0 | 2 | **NO** |
| 4 | 2 | North | 18 | 18 | 0 | 0 | 2 | **NO** |
| 4 | 2 | East | 18 | 18 | 0 | 0 | 2 | **NO** |
| 4 | 2 | South | 18 | 18 | 0 | 0 | 2 | **NO** |

# Problems

- I need to keep an individual record of which Tiles are still available for each row/wind instead of keeping just the "current_draw_index".
- I need to keep track of the total number of tiles currently available for each row/wind instead of just keeping the "total_tiles" variable.
- I need to consider that each row/wind on the table has two piles (Top and Bottom) and that I can have situations where the Top pile is empty but the Bottom pile is not.
- The players should draw only 13 tiles each, right now it goes forever, there is no stop condition.