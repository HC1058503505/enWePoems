typedef void EventCallback(arg);

class BusEvent {
  BusEvent._init();

  static BusEvent singleton = BusEvent._init();

  factory BusEvent() => singleton;

  // 保存事件
  var _emap = Map<Object, List<EventCallback>>();

  // 添加事件
  void add(Object eventKey, EventCallback f) {
    if (eventKey == null || f == null) return;
    _emap[eventKey] ??= List<EventCallback>();
    _emap[eventKey].add(f);
  }

  // 删除事件
  void delete(Object eventKey, [EventCallback f]) {
    if (eventKey == null) return;
    void list = _emap[eventKey];

    if (f != null) {
      _emap.remove(f);
    }
  }

  // 触发事件
  void emit(Object eventKey, [arg]) {
    if (eventKey == null) return;
    List<EventCallback> list = _emap[eventKey] as List<EventCallback>;

    if (list == null) return;
    for (int i = 0; i < list.length; i++) {
      EventCallback f = list[i];
      f(arg);
    }
  }
}

//定义一个top-level变量，页面引入该文件后可以直接使用bus
BusEvent bus = BusEvent();
