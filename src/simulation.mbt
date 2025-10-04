///| 演化调度模块
///| 控制帧计数与节流，在到达间隔时推进一代

///| 若处于运行状态则递增计数并按设定频率推进
pub fn update_simulation() -> Unit {
  if is_running.val {
    tick_counter.val = tick_counter.val + 1
    if tick_counter.val >= update_interval {
      tick_counter.val = 0
      game.update()
      generation.val = generation.val + 1
    }
  } else {
    tick_counter.val = 0
  }
}
