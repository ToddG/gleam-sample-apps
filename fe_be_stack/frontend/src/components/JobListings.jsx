import { useState, useEffect } from 'react';
import Spinner from './Spinner';
import JobListing from './JobListing';

// const delay = ms => new Promise(
//   resolve => setTimeout(resolve, ms)
// );

const JobListings = ( { isHome = false }) => {
  const [jobs, setJobs] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect( () => {
    const fetchJobs = async () => {
      const apiUrl = '/api/v1/jobs'
      try{
        const res = await fetch(apiUrl);
        console.log("res", res)
        const data = await res.json();
        console.log("data", data)
        const jobs = data.jobs
        console.log("jobs", data)
        const curJobs = isHome ? jobs.slice(0,3) : jobs
        console.log("curJobs", curJobs)
        setJobs(curJobs);
      }
      catch(error){
        console.log('error fetching data', error);
      }
      finally{
        setLoading(false);
        console.log("jobs", jobs);
      }
    }
    fetchJobs();
  }, []);
  
	return (
    <section className="bg-blue-50 px-4 py-10">
      <div className="container-xl lg:container m-auto">
        <h2 className="text-3xl font-bold text-indigo-500 mb-6 text-center">
          { isHome ? 'Recent Jobs' : 'Browse All Jobs'}
        </h2>
          { loading? (
            <Spinner loading={loading}/>
          ) : (
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {jobs.map((job) => (
              <JobListing key={job.id} job={ job }/>
            ))}
          </div>
          )}
      </div>
    </section>
	)
}
export default JobListings
