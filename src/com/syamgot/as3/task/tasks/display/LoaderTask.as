package com.syamgot.as3.task.tasks.display
{
	import com.syamgot.as3.task.Task;
	import com.syamgot.as3.task.utils.Progress;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.getTimer;

	/**
	 * 
	 * 
	 * 
	 */
	public class LoaderTask extends Task
	{

		/**
		 * 
		 * 新しい LoaderTask インスタンスを作成します.
		 * 
		 * @param requeset 
		 * @param context
		 * @param priority 
		 */
		public function LoaderTask(requeset:URLRequest, context:LoaderContext = null, priority:int = 1)
		{
			_request = requeset;
			_context = context;
			_loader = new Loader();

			_progress = new Progress();
			events(_loader.contentLoaderInfo);
			
			super(priority);
			
			name = 'LoaderTask' + id;
		}

		protected override function exec():void
		{
			if (!_isStarted)
			{
				_isStarted = true;
				_loader.load(_request, _context);
			}
		}

		/** ****************************************************************
		 * private properties
		 **************************************************************** */
		
		private var _context:LoaderContext;
		private var _isStarted:Boolean;
		private var _loader:Loader;
		private var _request:URLRequest;
		private var _time:int;
		private var _timeout:int = 15000;
		private var _progress:Progress;
		
		/** ****************************************************************
		 * getter setter
		 **************************************************************** */
		
		public function get loader():Loader
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
			
			if (getTimer() > _time + timeout) 
			{
				_loader.close();
				remove();	
				progress.timeout();
			}
			
			progress.progress(e.bytesLoaded);
		}
		
	}
}
