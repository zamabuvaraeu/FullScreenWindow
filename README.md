﻿# FullScreenWindow

Программа перечисляет доступные разрешения экрана. Пользователь выбирает требуемое разрешение, затем программа устанавливает разрешение и создаёт полноэкранное окно.

## Компиляция

Достаточно выполнить команду:

```
make.cmd
```

Программа может работать без библиотек времени выполнения, в этом случае конечный размер будет меньше:

```
call make.cmd exe release withoutruntime
```

