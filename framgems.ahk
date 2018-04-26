#persistent

settimer, detect_level_change, 100
settimer, update_game_time, 2000

global res_x := 3840
global res_y := 2160

global x_scale := res_x / 3840
global y_scale := res_y / 2160 

global grand_tour_x := 110 * x_scale
global grand_tour_y := 105 * y_scale

global tomb_x := 110 * x_scale
global tomb_y := 175 * y_scale

global house_x := 2200 * x_scale
global house_y := 1120 * y_scale

global mission_x := 1680 * x_scale
global mission_y := 1290 * y_scale

global start_x := 2080 * x_scale
global start_y := 1280 * y_scale

global complete_x := 445 * x_scale
global complete_y := 130 * y_scale

global exit_world_x := 1840 * x_scale
global exit_world_y := 1215 * y_scale

global continue_x := 1840 * x_scale
global continue_y := 1215 * y_scale

global formation_1_x := 20 * x_scale
global formation_1_y := 1995 * y_scale

global click_upgrade_button_x := 175 * x_scale
global click_upgrade_button_y := 2130 * y_scale

global bruenor_level_button_x := 345 * x_scale
global bruenor_level_button_y := 2130 * y_scale

global attack_x := [res_x * .50, res_x * .80, res_x * .95] 
global attack_y := [res_y * .35, res_y * .45, res_y * .55, res_y * .65]

global current_level := 0
global in_menu := 1
global in_game_time := 0
global black_count := 0

^r::reload ; Internal function
`::exit()
^g::go()

go()
{
  setmousedelay, 0
  in_menu := 0

  loop
  {
    ;start_mission()

    level := current_level

    loop
    {
      click_battlefield()
      upgrade_click()

      if(level != current_level)
      {
        upgrade()
        level := current_level
      }

      if(in_game_time > 1200) ; 20 minutes
        break
      
      if(current_level > 30)
        break
    }
    
    complete_mission()
  }
}

start_mission()
{
  click, %tomb_x%, %tomb_y%
  sleep, 250
  click, %grand_tour_x%, %grand_tour_y%
  sleep, 250
  click, %house_x%, %house_y%
  sleep, 250
  
  mousemove, %mission_x%, %mission_y%

  loop, 10
  {
    click, wheelup, 10
    sleep 25
  }

  loop, 3
  {
    click, wheeldown, 3
    sleep, 25
  }
  
  click
  sleep, 250

  click, %start_x%, %start_y%

  sleep, 7000

  current_level := 1
  in_menu := 0
}

click_battlefield()
{
  loop, 3
  {
    loop, 3
    {
      x := attack_x[A_index]
    
      loop, 4
      {
        y := attack_y[A_index]
        click, %x%, %y%
      }
    }
  }
}

upgrade_click()
{
  click, %click_upgrade_button_x%, %click_upgrade_button_y%
}

upgrade()
{
  x_diff := bruenor_level_button_x - click_upgrade_button_x

  loop, 10
  {
    x := click_upgrade_button_x + x_diff * (A_index - 1)
    click, %x%, %click_upgrade_button_y%
    sleep, 25
  }

  click, %formation_1_x%, %formation_1_y%
}

complete_mission()
{
  click, %complete_x%, %complete_y%
  sleep, 1000
  click, %exit_world_x%, %exit_world_y%

  in_menu := 1
  sleep, 12000

  click, %continue_x%, %continue_y%
}

exit()
{
  exitapp  
}

detect_level_change()
{ 
  mousegetpos, x, y
  pixelgetcolor, color, %x%, %y%, hex

  if(color = 000000 && in_menu = 0)
  {
    black_count += 1
  } 
  else
  {
    black_count := 0
  }

  if(black_count >= 5)
  {
    current_level += 1
    black_count := 0
  }
}

update_game_time()
{
  if(in_menu = 0)
  {
    in_game_time += 2
  }
}