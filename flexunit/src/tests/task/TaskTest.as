package tests.task
{
	import com.syamgot.as3.task.Task;

	import flexunit.framework.Assert;

	public class TaskTest
	{
		
		// ----------------------------------------
		// startup & teardowns
		// 

		[Before]
		public function setUp():void
		{
			Task.initialize();
		}
		
		[After]
		public function tearDown():void
		{
			Task.finalize();
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}


		// ----------------------------------------
		// startup & teardowns
		// 
		
		[Test]
		public function first():void
		{
			var task1:Task = new Task(2);
			var task2:Task = new Task(3);
			Assert.assertEquals(Task.first, task1);

			var task3:Task = new Task(1);
			Assert.assertEquals(Task.first, task3);
			Assert.assertEquals(Task.first, task3);
			Assert.assertEquals(Task.first, task3);
		}

		[Test]
		public function getTask():void
		{
			var task1:Task = new Task();
			var task2:Task = new Task();
			task1.name = 't1';
			task2.name = 't2';
			
			Assert.assertEquals(Task.getTask(1), task1);
			Assert.assertEquals(Task.getTask('t1'), task1);
			Assert.assertEquals(Task.getTask(2), task2);
			Assert.assertEquals(Task.getTask('t2'), task2);
			
			Assert.assertNull(Task.getTask(3));
			Assert.assertNull(Task.getTask('t3'));

			var task3:Task = new Task();
			task3.name = 't3';
			Assert.assertEquals(Task.getTask(3), task3);
			Assert.assertEquals(Task.getTask('t3'), task3);
		}

		[Test]
		public function remove():void
		{
			var task1:Task = new Task(1);
			var task2:Task = new Task(2);
			var task3:Task = new Task(3);

			task2.remove();

			Assert.assertEquals(task1.next, task3);
			Assert.assertEquals(task1.prev, task3);
			
			task1.remove();
			task3.remove();
			Assert.assertNull(Task.first);
			
			var task4:Task = new Task();
			Assert.assertTrue(task4.run());
		}

		[Test]
		public function run():void
		{
			var task1:Task = new Task(1);
			var task2:Task = new Task(2);
			var task3:Task = new Task(3);
			
			task1.run();
			Assert.assertEquals(Task.active, task3);
			
		}
		
		[Test]
		public function next():void 
		{
			
			var i:int, n:int = 1000;
			for (i = 0; i < n; i++) 
			{
				new Task(int(Math.random() * n)); 
			}
			
			for (i = 0; i < n; i++) 
			{
				if(Task.tasks[i].next != Task.first) 
				{
					Assert.assertTrue((Task.tasks[i].priority <= Task.tasks[i].next.priority));
				}
			}
			
		}
		
		[Test]
		public function prev():void 
		{
			
			var i:int, n:int = 1000;
			for (i = 0; i < n; i++) 
			{
				new Task(int(Math.random() * n)); 
			}
			
			for (i = 0; i < n; i++) 
			{
				if(Task.tasks[i] != Task.first) 
				{
					Assert.assertTrue((Task.tasks[i].priority >= Task.tasks[i].prev.priority));
				}
			}
			
		}

	}
}
