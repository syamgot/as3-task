package com.syamgot.as3.task.utils
{
	import com.syamgot.as3.task.utils.event.ProgressEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class Progress extends EventDispatcher
	{
		private var _loaded:uint;
		private var _total:uint;

		private var _isStarted:Boolean;
		private var _isTimeout:Boolean;
		private var _isFailed:Boolean;
		private var _isCompleted:Boolean;
		
		public function isStarted():Boolean
		{
			return _isStarted;
		}
		
		public function isTimeout():Boolean
		{
			return _isTimeout;
		}
		
		public function isFailed():Boolean
		{
			return _isFailed;
		}
		
		public function isCompleted():Boolean
		{
			return _isCompleted;
		}
		
		public function get total():uint
		{
			return _total;
		}

		public function get loaded():uint
		{
			return _loaded;
		}

		public function get percent():int
		{
			return Math.floor(loaded / total * 100);
		}
		
		public function start(value:uint):void
		{
			_isTimeout = false;
			_isCompleted = false;
			_isStarted = true;
			
			_total = value;
			
			dispatchEvent(new ProgressEvent(ProgressEvent.START));
		}
		
		public function complete():void 
		{
			_isCompleted = true;
			dispatchEvent(new ProgressEvent(ProgressEvent.COMPLETE));
		}
		
		public function fail():void
		{
			_isFailed = true;
			dispatchEvent(new ProgressEvent(ProgressEvent.FAIL));
		}
		
		public function timeout():void 
		{
			_isTimeout = true;
			dispatchEvent(new ProgressEvent(ProgressEvent.TIMEOUT));
		}
		
		public function progress(loaded:int):void 
		{
			_loaded = loaded;
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS));
		}
		
	}

}
