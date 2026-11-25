const ProfilePage = ({user, logout}) => {
	return (
	  <>
	  <div>
      <div className="container-xl lg:container m-auto">
        <div className="grid grid-cols-1 md:grid-cols-1 gap-4 p-4 rounded-lg">
          <pre>{JSON.stringify(user, null, 2)}</pre>
          <button
            className="bg-indigo-500 hover:bg-indigo-600 text-white text-center font-bold py-2 px-4 rounded-full w-full focus:outline-none focus:shadow-outline mt-4 block"
            onClick={logout}>Logout</button>
        </div>
      </div>
    </div>
		</>
	)
}
export default ProfilePage
