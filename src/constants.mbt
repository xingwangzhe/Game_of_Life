///| 游戏常量配置模块
///| 定义棋盘尺寸、布局参数、更新频率及调色枚举
///| 需求更新：去除文字 HUD，将网格覆盖整块 160x160 屏幕
///| 再次更新：添加左右侧信息/操作面板（将使用覆盖透明矩形与文本）

///| 棋盘维度
// 使用 40x40 * 4 像素单元 = 160 像素，充满整个屏幕
pub let board_cols : Int = 40
pub let board_rows : Int = 40
pub let cell_size : Int = 4

///| 计算出的布局参数（像素尺寸 / 原点 / HUD 位置）
pub let board_pixels : Int = board_cols * cell_size   // 160
pub let board_origin_x : Int = 0                      // 左上对齐
pub let board_origin_y : Int = 0                      // 顶部对齐（无 HUD 区域）
// hud_y 移除：不再绘制文字


///| 模拟速度（多少帧推进一代）
pub let update_interval : Int = 6

