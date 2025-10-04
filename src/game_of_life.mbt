///| 生命游戏核心数据结构与规则实现
pub struct GameOfLife {
  width : Int
  height : Int
  mut current : Array[Bool]
  mut next : Array[Bool]
}

///| 创建指定宽高的生命游戏实例
pub fn GameOfLife::new(width : Int, height : Int) -> GameOfLife {
  let size = width * height
  {
    width,
    height,
    current: Array::make(size, false),
    next: Array::make(size, false),
  }
}

///| 读取坐标 (x, y) 处细胞是否存活（越界返回 false）
pub fn get_cell(self : GameOfLife, x : Int, y : Int) -> Bool {
  if x < 0 || x >= self.width || y < 0 || y >= self.height {
    false
  } else {
    self.current[y * self.width + x]
  }
}

///| 设置坐标 (x, y) 的细胞存活状态（忽略越界）
pub fn set_cell(self : GameOfLife, x : Int, y : Int, alive : Bool) -> Unit {
  if x >= 0 && x < self.width && y >= 0 && y < self.height {
    self.current[y * self.width + x] = alive
  }
}

///| 获取棋盘宽度
pub fn get_width(self : GameOfLife) -> Int {
  self.width
}

///| 获取棋盘高度
pub fn get_height(self : GameOfLife) -> Int {
  self.height
}

///| 切换指定坐标细胞状态（存活 -> 死亡 / 死亡 -> 存活）
pub fn toggle_cell(self : GameOfLife, x : Int, y : Int) -> Unit {
  let current = self.get_cell(x, y)
  self.set_cell(x, y, not(current))
}

///| 将所有细胞清空为死亡状态
pub fn clear(self : GameOfLife) -> Unit {
  let size = self.width * self.height
  for i = 0; i < size; i = i + 1 {
    self.current[i] = false
    self.next[i] = false
  }
}

///| 统计 (x, y) 周围 8 邻域存活细胞数量
pub fn count_neighbors(self : GameOfLife, x : Int, y : Int) -> Int {
  let mut count = 0
  for dx = -1; dx <= 1; dx = dx + 1 {
    for dy = -1; dy <= 1; dy = dy + 1 {
      if dx != 0 || dy != 0 {
        if self.get_cell(x + dx, y + dy) {
          count = count + 1
        }
      }
    }
  }
  count
}

///| 演化一步（生成下一代并交换缓冲区）
pub fn update(self : GameOfLife) -> Unit {
  // 计算下一代状态
  for y = 0; y < self.height; y = y + 1 {
    for x = 0; x < self.width; x = x + 1 {
      let neighbors = self.count_neighbors(x, y)
      let alive = self.get_cell(x, y)
      let next_alive = match (alive, neighbors) {
        (true, 2) | (true, 3) => true
        (false, 3) => true
        _ => false
      }
      self.next[y * self.width + x] = next_alive
    }
  }

  // 交换双缓冲
  let temp = self.current
  self.current = self.next
  self.next = temp
}

///| 在指定起点放置滑翔机（Glider）模式
pub fn setup_glider(self : GameOfLife, start_x : Int, start_y : Int) -> Unit {
  // 滑翔机五个点位
  self.set_cell(start_x + 1, start_y, true)
  self.set_cell(start_x + 2, start_y + 1, true)
  self.set_cell(start_x, start_y + 2, true)
  self.set_cell(start_x + 1, start_y + 2, true)
  self.set_cell(start_x + 2, start_y + 2, true)
}


