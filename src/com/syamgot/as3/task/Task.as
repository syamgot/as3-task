package com.syamgot.as3.task {

	import flash.utils.getTimer;

	public class Task {

		/** ****************************************************************
		 * static properties
		 **************************************************************** */

		protected static var _active:Task;
		protected static var _count:int;
		protected static var _first:Task;
		protected static var _tasks:Vector.<Task>;
		protected static var _isReady:Boolean;
		protected static var _isRunning:Boolean;


		/**
		 * タスクリストを返す.
		 * 
		 * @return 
		 * 
		 */
		public static function get tasks():Vector.<Task> {
			return _tasks;
		}

		/**
		 * 最初に実行されるタスクを返す.
		 * 
		 * @return 
		 * 
		 */
		public static function get first():Task {
			return _first;
		}

		/**
		 * 今実行されているタスクを返す. 
		 * 
		 * @return 
		 * 
		 */
		public static function get active():Task {
			return _active;
		}

		/**
		 * タスクの数を返す.
		 * 
		 * @return 
		 * 
		 */
		public static function get count():int {
			return _count;
		}

		/** ****************************************************************
		 * static methods
		 **************************************************************** */

		/**
		 * 実行中ならtrueを返す.
		 * 
		 * @return 
		 * 
		 */
		public static function isRunning():Boolean {
			return _isRunning;
		}

		/**
		 * 実行できるならtrueを返す.
		 * 
		 * @return 
		 * 
		 */
		public static function isReady():Boolean {
			return _isReady;
		}

		/**
		 * タスクを取得する.
		 * 
		 * 引数がintなら該当するインデックスのインスタンスを返す.
		 * 引数がstringなら該当する名前のインスタンスを返す.
		 * 存在しなければnullを返す.
		 * 
		 * @param val
		 * @return 
		 * 
		 */
		public static function getTask(val:*):Task {

			if (_tasks == null) {
				return null;
			}

			if (val is int) {
				if (_tasks.length < val) {
					return null;
				}
				return _tasks[val - 1];
			} 
			else if (val is String) {
				var i:int, n:int = _tasks.length;
				for (i = 0; i < n; i++) {
					if (_tasks[i].name == val) {
						return _tasks[i];
					}
				}

			}

			return null;
		}

		/**
		 * 全てのタスクの情報をダンプする.
		 * 
		 * @return 
		 * 
		 */
		public static function dumpAll():String {
			var str:String = '';
			if (_isReady) {
				str += '>> Task.dumpAll start ------------------------------------' + "\n"
				str += 'first : ' + Task.first.id + ', ' + Task.first.name + "\n";
				var i:uint, n:uint = _tasks.length;
				for (i = 0; i < n; i++) {
					str += _tasks[i].dump();
				}
				str += '>> Task.dumpAll end ------------------------------------' + "\n"
			}
			return str;
		}

		/**
		 * 全てのタスクの情報を優先度順にダンプする.
		 * 
		 * @return 
		 * 
		 */
		public static function dumpAllSortByPriority():String {
			var str:String = '';
			if (_isReady) {
				str += '>> Task.dumpAllSortByPriority start ------------------------------------' + "\n"
				str += 'first : ' + Task.first.id + ', ' + Task.first.name + "\n";
				var task:Task, next:Task;
				for (task = first; first; task = next) {
					_active = task;
					str += task.dump();
					next = task.next;
					if (next == first) {
						break;
					}
				}
				str += '>> Task.dumpAll end ------------------------------------' + "\n"
			}
			return str;
		}


		/** ****************************************************************
		 * private & protected methods
		 **************************************************************** */

		/**
		 * 新しいタスクを追加する.
		 * 
		 * 同じ優先度なら、追加された順に実効する.
		 * 
		 * @param newTask
		 * @return 
		 * 
		 */
		private function add(newTask:Task):Task {
			var task:Task, next:Task;
			for (task = first; ; task = next) {
				next = task.next;
				if (newTask.priority < task.priority) {
					if (task == first) {
						_first = newTask;
					}
					newTask.prev = task.prev;
					newTask.next = task;
					break;
				} else if (next == first) {
					newTask.prev = task;
					newTask.next = next;
					break;
				}
			}
			newTask.prev.next = newTask;
			newTask.next.prev = newTask;

			return this;
		}

		/**
		 * タスクを実行する.
		 * 
		 * 派生クラスはこのメソッドをオーバーライドして利用する.
		 * 
		 * 
		 */
		protected function exec():void {

		}


		/** ****************************************************************
		 * public methods
		 **************************************************************** */

		/**
		 * 全てのタスクを開放する. 
		 * 
		 */
		public static function finalize():void {
			for (var i:uint = 0; i < _count; i++) {
				if (_tasks[i]) {
					_tasks[i].release();
				}
			}

			_count = 0;
			_active = null;
			_first = null;
			_tasks = null;
			_isReady = false;
			_isRunning = false;
		}

		/**
		 * タスクを初期化する.
		 * 
		 * タスクを利用する前に、必ず実行する必要がある.
		 * 
		 */
		public static function initialize():void {
			_count = 0;
			_active = null;
			_first = null;
			_tasks = new Vector.<Task>;
			_isReady = true;
			_isRunning = false;
		}


		/**
		 * 新しいTaskインスタンスを生成する.
		 * 
		 * @param priority
		 * 
		 */
		public function Task(priority:int = 5) {

			if (!_tasks) {
				_tasks = new Vector.<Task>;
			}
			_tasks.push(this);

			_priority = priority;
			_id = ++_count;
			_name = 'Task' + id;

			if (!first) {
				this.next = this;
				this.prev = this;
				_first = this;
			} else {
				first.add(this);
			}

		}

		/**
		 * タスクを取り除く.
		 * 
		 * 取り除かれたタスクは開放されるわけではない
		 * 
		 * @return 
		 * 
		 */
		public final function remove():Task {
			if (this == first) {
				if (next == first) {
					_first = null;
				} else {
					_first = next;
				}
			}

			prev.next = next;
			next.prev = prev;
			_isRemoved = true;
			return this;
		}

		/**
		 * TODO タスクを開放する.
		 * 
		 */
		public final function release():void {
			// delete this;
		}

		/**
		 * タスクを実行する.
		 * 
		 * @return 
		 * 
		 */
		public final function run():Boolean {

			if (Task.isRunning() || !Task.isReady() || Task.first == null) {
				return false;
			} else {
				_isRunning = true;
			}

			var task:Task, next:Task;
			for (task = first; first; task = next) {
				if (task == first) {
					_startTime = getTimer();
				}

				_active = task;
				if (!task.isRemoved()) {
					var t:int = getTimer();
					task.exec();
					_execTime = getTimer() - t;
				}
				next = task.next;

				if (next == first) {
					_isRunning = false;
					break;
				}
			}

			return true;
		}

		/**
		 * removeされているならtrueを返す.
		 * 
		 * @return 
		 * 
		 */
		public function isRemoved():Boolean {
			return _isRemoved;
		}

		/**
		 * 文字列として返す. 
		 * 
		 * @return 
		 * 
		 */
		public function toString():String {
			return '[Task : ' + 'id=' + _id + ' name=' + _name + ' ]';
		}

		/**
		 * 情報をダンプする.
		 * 
		 * @return 
		 * 
		 */
		public function dump():String {
			var str:String = '';
			str += '>> Task.dump start ------------------------------------' + "\n"
			str += 'id : ' + id + "\n"
			str += 'name : ' + name + "\n"
			str += 'isRemoved : ' + isRemoved() + "\n"
			str += 'execTime : ' + execTime + "\n"
			str += '>> Task.dump end ------------------------------------' + "\n"
			return str;
		}


		/** ****************************************************************
		 * private properties
		 **************************************************************** */

		private var _id:int;
		private var _name:String;
		private var _next:Task;
		private var _prev:Task;
		private var _priority:int;
		private var _startTime:int;
		private var _execTime:int;
		private var _isRemoved:Boolean;


		/** ****************************************************************
		 * getter setter
		 **************************************************************** */

		public function get id():int {
			return _id;
		}

		public function get name():String {
			return _name;
		}

		public function set name(value:String):void {
			_name = value;
		}

		public function get next():Task {
			return _next;
		}

		public function set next(value:Task):void {
			_next = value;
		}

		public function get prev():Task {
			return _prev;
		}

		public function set prev(value:Task):void {
			_prev = value;
		}

		public function get priority():int {
			return _priority;
		}

		public function get startTime():int {
			return _startTime;
		}

		public function get execTime():int {
			return _execTime;
		}

	}
}
