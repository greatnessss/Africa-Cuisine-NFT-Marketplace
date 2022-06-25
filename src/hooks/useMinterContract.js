import {useContract} from './useContract';
import AfricanCuisineNFTAbi from '../contracts/AfricanCuisine.json';
import AfricanCuisineNFTContractAddress from '../contracts/AfricanCuisineNFT-address.json';


// export interface for NFT contract
export const useMinterContract = () => useContract(AfricanCuisineNFTAbi.abi, AfricanCuisineNFTContractAddress.AfricanCuisineNFT);
