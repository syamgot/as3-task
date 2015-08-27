package com.syamgot.as3.task.tasks.net
{
	import com.syamgot.as3.task.Task;
	import com.syamgot.as3.task.utils.Progress;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getTimer;

	public class URLLoaderTask extends Task
	{

		public function URLLoaderTask(requeset:URLRequest, priority:int = 1)
		{
			_request = requeset;
			_loader = new URLLoader();

			_progress = new Progress();
			events(_loader);

			super(priority);
			
			name = 'URLLoaderTask' + id;
		}

		protected override function exec():void
		{
			if (!_isStarted)
			{
				_isStarted = true;
				_loader.load(_request);
			}
		}

		/** ****************************************************************
		 * private properties
		 **************************************************************** */
		
		private var _isStarted:Boolean;
		private var _loader:URLLoader;
		private var _request:URLRequest;
		private var _time:int;
		private var _timeout:int = 15000;
		private var _progress:Progress;
		
		
		/** ****************************************************************
		 * getter setter
		 **************************************************************** */
		
		public function get loader():URLLoader
		{
			return _loader;
		}
		
		public function get timeout():int
		{
			return _timeout;
		}
		
		public function set timeout(val:int):void 
		{
			_timeout = val;
		}
		
		public function get progress():Progress 
		{
			return _progress;
		}
		
		/** ****************************************************************
		 * events
		 **************************************************************** */
		
		private function events(dispacher:EventDispatcher):void
		{
			dispacher.addEventListener(Event.COMPLETE, completeHandler);
			dispacher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispacher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		private function completeHandler(e:Event):void
		{
			progress.complete();
			remove();
		}

		private function ioErrorHandler(e:IOErrorEvent):void
		{
			progress.fail();
			remove();
		}

		private function progressHandler(e:ProgressEvent):void
		{
			if (!progress.isStarted()) 
			{
				_time = getTimer();
				progress.start(e.bytesTotal);
			}
			
			if (getTimer() > _time + _timeout) 
			{
				_loader.close();
				remove();	
				progress.timeout();
			}
			
			progress.progress(e.bytesLoaded);
		}
		
	}
}
