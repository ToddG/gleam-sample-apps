import {
  Form,
  // FormLabel,
  FormField,
  FormInput,
  FormSelect,
  FormSubmit,
  useFormSubmit,
  useFormStore,
} from '../components/AriaForm.jsx'
import { SelectItem } from "../components/AriaSelect.jsx";
import "../components/AriaFormStyle.css";
import { useNavigate } from "react-router-dom";
import {toast} from 'react-toastify';

const AddJobPage2 = ({ addJobSubmit }) => {
    const navigate = useNavigate();
    const form = useFormStore(
      { defaultValues:
        {
          title: "",
          type: "",
          location: "",
          description: "",
          salary: "",
          company: {
            name: "",
            description: "",
            contactEmail: "",
            contactPhone: "",
          }
        }
      }
    );
    const $ = form.names

    useFormSubmit(form, () => {
      // alert(JSON.stringify(form.getState().values));
      const newJob = form.getState().values
      addJobSubmit(newJob)
      toast.success("job added successfully");
      return navigate('/jobs')
    });

    return (
    <section className="bg-indigo-50">
      <div className="container m-auto max-w-2xl py-24">
        <h2 id="add-new-job" className="heading">
          Add Job
        </h2>
        <div
          className="bg-white px-6 py-8 mb-4 shadow-md rounded-md border m-4 md:m-0"
        >
        <Form store={form} >
          <FormField name={$.title} label="Job Title">
            <FormInput name={$.title} placeholder="A Cool Job Title.." className="input" required />
          </FormField>
          <FormField name={$.type} label="Job Type">
            <FormSelect name={$.type} required>
              <SelectItem value="Full-Time"/>
              <SelectItem value="Part-Time"/>
              <SelectItem value="Remote"/>
              <SelectItem value="Internship"/>
            </FormSelect>
          </FormField>
          <FormField name={$.location} label="Job Location">
            <FormInput name={$.location} placeholder="Cool job location ..." className="input" required />
          </FormField>
          <FormField name={$.description} label="Job Description">
            <FormInput name={$.description} placeholder="Cool job description..." className="input" required />
          </FormField>
          <FormField name={$.salary} label="Job Salary">
            <FormSelect name={$.salary} required>
              <SelectItem value="<50K"/>
              <SelectItem value="50K - 100K"/>
              <SelectItem value="100K - 200K"/>
              <SelectItem value="200K - 300K"/>
              <SelectItem value=">300K"/>
            </FormSelect>
          </FormField>
          <FormField name={$.company.name} label="Company Name">
            <FormInput name={$.company.name} placeholder="Cool company name..." className="input" required />
          </FormField>
          <FormField name={$.company.description} label="Company Description">
            <FormInput name={$.company.description} placeholder="Cool company description..." className="input" required />
          </FormField>
          <FormField name={$.company.contactEmail} label="Company Contact Email">
            <FormInput name={$.company.contactEmail} placeholder="foo@bar.com" className="input" required />
          </FormField>
          <FormField name={$.company.contactPhone} label="Company Contact Phone">
            <FormInput name={$.company.contactPhone} placeholder="+1.555.555.5555" className="input" required />
          </FormField>
          <div className="bg-indigo-500 hover:bg-indigo-600 text-white font-bold py-2 px-4 rounded-full w-full focus:outline-none focus:shadow-outline" type="submit" >
            <FormSubmit>Submit</FormSubmit>
          </div>
      </Form>
    </div>
  </div>
</section>
    );
}
export default AddJobPage2

