package com.syamgot.as3.task.utils
{
	import com.syamgot.as3.task.utils.event.ProgressEvent;
	import com.syamgot.as3.util.external.External;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	

	public class ParallelProgress extends EventDispatcher
	{
	
		public function ParallelProgress() 
		{
			initialize();	
		}
		
		private function initialize():void 
		{
			_progresses = new Vector.<Progress>;
			_isStarted = false;
			_isFailed = false;
			_isTimeout = false;
			_isCompleted = false;
		}
		
		private function finalize():void {}
		
		private var _progresses:Vector.<Progress>;
		
		private var _isStarted:Boolean;
		private var _isFailed:Boolean;
		private var _isTimeout:Boolean;
		private var _isCompleted:Boolean;
		
		public function isStarted():Boolean
		{
			return _isStarted;
		}
		
		public function isFailed():Boolean
		{
			return _isFailed;
		}
		
		public function isTimeout():Boolean
		{
			return _isTimeout;
		}
		
		public function isCompleted():Boolean
		{
			return _isCompleted;
		}
		
		
		
		public function get total():int
		{
			var i:uint, n:uint = _progresses.length, res:uint = 0;
			for (i = 0; i < n; i++) 
			{
				res += _progresses[i].total;
			}
			return res;
		}
		
		public function get loaded():int
		{
			var i:uint, n:uint = _progresses.length, res:uint = 0;
			for (i = 0; i < n; i++) 
			{
				res += _progresses[i].loaded;
			}
			return res;
		}
		
		public function add(progress:Progress):ParallelProgress 
		{
			events(progress);
			_progresses.push(progress);
			return this;
		}
		
		private function events(dispacher:EventDispatcher):void 
		{
			dispacher.addEventListener(ProgressEvent.START, startHandler);
			dispacher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispacher.addEventListener(ProgressEvent.FAIL, failHandler);
			dispacher.addEventListener(ProgressEvent.COMPLETE, completeHandler);
			dispacher.addEventListener(ProgressEvent.TIMEOUT, timeoutHandler);
		}
		
		private function startHandler(e:ProgressEvent):void 
		{
			if (!_isStarted) 
			{
				_isStarted = true;
				dispatchEvent(new ProgressEvent(ProgressEvent.START));
			}
		}
		
		private function progressHandler(e:ProgressEvent):void 
		{
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS));
		}
		
		private function failHandler(e:ProgressEvent):void 
		{
			_isFailed = true;
			dispatchEvent(new ProgressEvent(ProgressEvent.FAIL));
		}
		
		private function timeoutHandler(e:ProgressEvent):void 
		{
			_isTimeout = true;
			dispatchEvent(new ProgressEvent(ProgressEvent.TIMEOUT));
		}
		
		private function completeHandler(e:ProgressEvent):void 
		{
			_isCompleted = true;
			var i:uint, n:uint = _progresses.length;
			for (i = 0; i < n; i++) 
			{
				if (!_progresses[i].isCompleted()) 
				{
					_isCompleted = false;
				}
			}
			
			if (_isCompleted) 
			{
				_isStarted = false;
				dispatchEvent(new ProgressEvent(ProgressEvent.COMPLETE));
			}
		}
		
	}
}