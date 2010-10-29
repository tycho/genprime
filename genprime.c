
#define _GNU_SOURCE

#include <math.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#ifdef __linux
#include <sched.h>
#endif

#ifdef _WIN32
#include <windows.h>
typedef HRESULT (CALLBACK * P_DwmIsCompositionEnabled)(BOOL *pfEnabled);
typedef HRESULT (CALLBACK * P_DwmEnableComposition)   (BOOL   fEnable);
#else
#include <signal.h>
#include <pthread.h>
#include <unistd.h>
#endif

/* #define USE_CACHE /* */

typedef unsigned long prime_t;
typedef int BOOL;
#define TRUE -1
#define FALSE 0

#ifdef USE_CACHE
prime_t primeCache[65536];
const prime_t *cacheEnd = &primeCache[65535];
prime_t *cachePtr = primeCache;
#endif

#ifdef _WIN32
HMODULE dwmapi = NULL;
HANDLE hIdleThread = NULL;
#else
pid_t hIdleProcess;
#endif
volatile BOOL bIdleRunning = TRUE;

#ifdef _WIN32
unsigned long long freq = 0;
double tickInterval = 0.0;
#endif

BOOL isprime(prime_t x)
{
	prime_t lim, y = 0;
#ifdef USE_CACHE
	prime_t const *p = primeCache;
#endif
	if (x < 2)
		return FALSE;
	if (x == 2)
		return TRUE;
	if (x % 2 == 0)
		return FALSE;
	if (x < 9)
		return TRUE;
	if ((x + 1) % 6 != 0)
		if ((x - 1) % 6 != 0)
			return FALSE;
	lim = (prime_t)(sqrt((double)x) + 1.0f);
#ifdef USE_CACHE
	while (p < cachePtr && (y = *p) != 0 && y < lim) {
		if (x % y == 0)
			return FALSE;
		p++;
	}
	if (!y)
#endif
		y = 3;
	for (; y < lim; y += 2)
	{
		if (x % y == 0)
			return FALSE;
	}
	return TRUE;
}

prime_t genprime(prime_t max)
{
	prime_t count = 0,
		current = 1;
	while (count < max)
	{
		if (isprime(current)) {
#ifdef USE_CACHE
			if (cachePtr <= cacheEnd)
				*cachePtr++ = current;
#endif
			count++;
		}
		current++;
	}
	return current - 1;
}

#ifdef _WIN32
DWORD WINAPI idle_thread(LPVOID param)
#else
void idle_thread()
#endif
{
#ifdef _WIN32
	while(bIdleRunning);
	ExitThread(0);
#else
	while(1);
#endif
}

void spawn_idle()
{
	printf("[M] Spawning idle thread and waiting a couple of seconds...\n");
	bIdleRunning = TRUE;
#ifdef _WIN32
	hIdleThread = CreateThread(NULL, 0, idle_thread, NULL, CREATE_SUSPENDED, NULL);
	SetThreadAffinityMask(hIdleThread, 1);
	SetThreadPriority(hIdleThread, THREAD_PRIORITY_IDLE);
	ResumeThread(hIdleThread);
	Sleep(5000);
#else
	{
		hIdleProcess = fork();
		if (hIdleProcess < 0) {
			printf("[E] Fork failed\n");
			exit(1);
		} else if (hIdleProcess == 0) {
			pthread_t self;
			int iret;
			struct sched_param thread_param;
			self = pthread_self();
			memset(&thread_param, 0, sizeof(struct sched_param));
			thread_param.sched_priority = sched_get_priority_min(SCHED_IDLE);
			pthread_setschedparam(self, SCHED_IDLE, &thread_param);
			idle_thread();
		}
	}
	sleep(3);
#endif
}

void prepare()
{
	printf("[M] Setting process affinity...\n");
	{
#ifdef _WIN32
		HANDLE process = GetCurrentProcess();
		SetProcessAffinityMask(process, 1);
#endif
#ifdef __linux
		pid_t process;
		cpu_set_t set;
		CPU_ZERO(&set);
		CPU_SET(0, &set);
		process = getpid();
		sched_setaffinity(process, sizeof(cpu_set_t), &set);
#endif
	}
	
	printf("[M] Setting thread priority...\n");
	{
#ifdef _WIN32
		HANDLE thread = GetCurrentThread();
		SetThreadPriority(thread, THREAD_PRIORITY_TIME_CRITICAL);
#else
		pthread_t self;
		int iret;
		struct sched_param thread_param;
		self = pthread_self();
		memset(&thread_param, 0, sizeof(struct sched_param));
		thread_param.sched_priority = sched_get_priority_max(SCHED_RR);
		pthread_setschedparam(self, SCHED_RR, &thread_param);
#endif
	}

#ifdef _WIN32
	/* Use a do-while loop with null condition, just so we can
	   conveniently use 'break;'.
	 */
	do {
		BOOL enabled;
		P_DwmIsCompositionEnabled fIsEnabled;
		P_DwmEnableComposition    fEnable;
		dwmapi = LoadLibrary("dwmapi.dll");
		if (!dwmapi)
			break;
		fIsEnabled = GetProcAddress(dwmapi, "DwmIsCompositionEnabled");
		if (!fIsEnabled)
			break;
		fEnable = GetProcAddress(dwmapi, "DwmEnableComposition");
		if (!fEnable)
			break;
		printf("[M] Windows Vista/7 detected, disabling composition...\n");
		if (SUCCEEDED(fIsEnabled(&enabled)) && enabled)
			fEnable(FALSE);

		Sleep(1500);
	} while(0);
#endif
}

void cleanup()
{
	printf("[M] Cleaning up...\n");
	bIdleRunning = FALSE;
#ifdef _WIN32
	if (dwmapi)
		FreeLibrary(dwmapi);
	if (hIdleThread) {
		WaitForSingleObject(hIdleThread, INFINITE);
		CloseHandle(hIdleThread);
	}
#else
	kill(hIdleProcess, SIGKILL);
#endif
}

#ifdef _WIN32
void calcfreq()
{
	QueryPerformanceFrequency(&freq);
	tickInterval = 1.0 / (double)freq;
}
#endif

inline double gettime()
{
#ifdef _WIN32
	unsigned long long tick;
	if (!freq) {
		calcfreq();
	}
	QueryPerformanceCounter(&tick);
	return (double)tick * tickInterval;
#else
	struct timeval t;
	gettimeofday(&t, NULL);
	return t.tv_sec + (t.tv_usec / 1000000.0);
#endif
}

int main(int argc, char **argv)
{
	prime_t start = argc > 1 ? atol(argv[1]) : 0,
		stop = argc > 2 ? atol(argv[2]) + 1 : 0,
		x, last;
	double begin, end;
	double duration;
	printf("[A] GenPrime v1.0\n");
	if (!start) start = 25000;
	if (!stop) stop = 1000001;
	prepare();
	spawn_idle();
	gettime(); gettime();
#ifdef USE_CACHE
	memset(primeCache, 0, sizeof(primeCache));
#endif
	for (x = start; x < stop; x += start)
	{
		begin = gettime();
		last = genprime(x);
		end = gettime();
		duration = end - begin;
		printf ("[%c] Found %8lu primes in %10.6f seconds (last was %10lu)\n",
#ifdef USE_CACHE
			'C',
#else
			'U',
#endif
			x, duration, last);
	}
	cleanup();
	return 0;
}
