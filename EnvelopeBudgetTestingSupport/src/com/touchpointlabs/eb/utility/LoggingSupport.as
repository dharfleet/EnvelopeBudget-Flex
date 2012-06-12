/**
 Copyright © 2012 Daniel Harfleet. All Rights Reserved.

  Redistribution and use in source and binary forms, with or without modification, are
  permitted provided that the following conditions are met:

  1. Redistributions of source code must retain the above copyright notice, this list
  of conditions and the following disclaimer.

  2. Redistributions in binary form must reproduce the above copyright notice, this
  list of conditions and the following disclaimer in the documentation and/or other
  materials provided with the distribution.

  3. The name of the author may not be used to endorse or promote products derived from
  this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY The Copyright Holder "AS IS" AND ANY EXPRESS OR IMPLIED
  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
  AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE
  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
  IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
package com.touchpointlabs.eb.utility
{
	import asmock.framework.MockRepository;
	import asmock.framework.SetupResult;

	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;

	/**
	 * provides a mock LogFactory which returns a mock log
	 * <p>
	 */
	public class LoggingSupport
	{

		public static var LOG_LEVEL_FATAL : int = 0;
		public static var LOG_LEVEL_ERROR : int = 1;
		public static var LOG_LEVEL_WARN : int = 2;
		public static var LOG_LEVEL_INFO : int = 3;
		public static var LOG_LEVEL_DEBUG : int = 4;


		public static function mockLogger() : LogFactory
		{
			return mockLoggerForClass();
		}

		/**
		 * @param classToProvideMockFor - if provided, the mock will ensure that only calls made to the LogFactory to get a logger for the given class will pass, if its null then any getLogger class param can be given
		 * @param unused an instance of MockRepository, this is no longer used as the class creates its own internal mockRepository. Future will be refactored out
		 * @param loggingLevel logging level required
		 * @param handleLogCalls SetupResults for call to logging
		 * @deprecated - prefer mockLogger() instead
		 */
		public static function mockLoggerForClass(classToProvideMockFor : Class=null, unused : MockRepository=null, loggingLevel : int=4, handleLogCalls : Boolean=true) : LogFactory
		{
			var mockRepository : MockRepository = new MockRepository();
			var factory : LogFactory = LogFactory(mockRepository.createStrict(LogFactory));
			var logger : Logger = Logger(mockRepository.createStrict(Logger));
			if (classToProvideMockFor != null)
			{
				SetupResult.forCall(factory.getLogger(classToProvideMockFor)).returnValue(logger);
			}
			else
			{
				SetupResult.forCall(factory.getLogger(null)).ignoreArguments().returnValue(logger);
			}

			if (handleLogCalls)
			{
				setupResultsForCallsToLogMethods(logger);
			}

			setupResultsForLogLevelEnabledCalls(logger, loggingLevel);

			mockRepository.replay(factory);
			mockRepository.replay(logger);

			return factory;
		}


		private static function setupResultsForCallsToLogMethods(logger : Logger) : void
		{
			SetupResult.forCall(logger.debug(null)).ignoreArguments();
			SetupResult.forCall(logger.info(null)).ignoreArguments();
			SetupResult.forCall(logger.warn(null)).ignoreArguments();
			SetupResult.forCall(logger.error(null)).ignoreArguments();
			SetupResult.forCall(logger.fatal(null)).ignoreArguments();
			SetupResult.forCall(logger.prettyPrintObjectIfDebugEnabled(null, null)).ignoreArguments();
		}


		private static function setupResultsForLogLevelEnabledCalls(logger : Logger, logLevel : int) : void
		{
			SetupResult.forCall(logger.isFatalEnabled).returnValue(logLevel >= LOG_LEVEL_FATAL);
			SetupResult.forCall(logger.isErrorEnabled).returnValue(logLevel >= LOG_LEVEL_ERROR);
			SetupResult.forCall(logger.isWarningEnabled).returnValue(logLevel >= LOG_LEVEL_FATAL);
			SetupResult.forCall(logger.isInfoEnabled).returnValue(logLevel >= LOG_LEVEL_FATAL);
			SetupResult.forCall(logger.isDebugEnabled).returnValue(logLevel >= LOG_LEVEL_FATAL);
		}
	}
}
